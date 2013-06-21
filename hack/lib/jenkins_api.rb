require 'net/http'
require 'uri'
require 'json'

module JenkinsNotifier

  # Encapsulate communication with jenkins
  class JenkinsApi

    def initialize(configuration)
      @configuration = configuration
      @server_url = configuration[:server_url] #get URL
      unless @server_url.end_with? '/' #append '/' 
        @server_url << '/'
      end
      Log.debug "Server url is [#@server_url]"
      Log.debug 'Fetching list of jobs'

      uri = "#{@server_url}api/json"
      begin
        response = execute_request(uri)
      rescue Errno::ECONNREFUSED
        Notifier.notify("Can't connect to #{uri}], quitting program", uri)
        raise JenkinsException
      end
      if response.code == '401'
        Notifier.notify('Connection to the server not authorized, you should perhaps provide some credentials, quitting program', uri)
        STDOUT << "#{response.body}\n"
        raise JenkinsException
      elsif response.code != '200'
        Notifier.notify("Server responded with code #{response.code} [#{response.body}], quitting program", uri)
        STDOUT << "#{response.body}\n"
        raise JenkinsException
      end
      begin
        parsed_response = JSON.parse(response.body, :symbolize_names => true)
      rescue JSON::ParserError
        Notifier.notify("Invalid response from the server [#{response.body}], quitting program", uri)
        raise JenkinsException
      end
      jobs = parsed_response[:jobs] || []
      if jobs.empty?
        Notifier.notify("No job found on server, quitting program", uri)
        raise JenkinsException
      end
      Notifier.notify("Connection to server successful", uri)

      @jobs = jobs.collect { |job| {:name => job[:name], :url => job[:url]} } #collect list of all jobs
      fetch_jobs(true)
    end

    def fetch_jobs(initial = false)
      filter_list= @configuration[:projects]
      @jobs.each do |job|
        if (!filter_list.nil? and filter_list.include?(job[:name])) #filter jobs
          fetch_job(job, initial) #fetch job details
        end
      end
    end

    private

    def fetch_job(job, initial)
      Log.debug "Fetching job #{job}"
      parsed_response = fetch_data("#{job[:url]}api/json")
      unless (last_build = parsed_response[:lastBuild])
        return
      end
      #if initial
       # job[:last_build_id] = last_build[:number]
      #else
       #if job[:name] == "acdata"
          fetch_build job, last_build[:number], last_build[:url]

       # end
      #end
    end

    def talk(job_name, status)
      if (status == 'FAILURE')
           system "say the #{job_name} build has failed."
      elsif (status == 'SUCCESS')
           system "say the #{job_name} build has been fixed."
      end
    end    

    def fetch_build(job, build_id, build_url)
      job_name = job[:name]

      Log.debug "Fetching build #{build_url} for #{job} "
      parsed_response = fetch_data("#{build_url}api/json")
      talk = @configuration[:talk]
      if (talk) 
        talk(job_name, parsed_response[:result])
      end
      Notifier.notify_execution(
        job_name,
        parsed_response[:fullDisplayName],
        parsed_response[:result],
        parsed_response[:url],
        parsed_response[:duration],
        job[:last_execution]
      )
      #talk(job[:name], parsed_response[:result])
      job[:last_build_id] = build_id
      job[:last_execution] = parsed_response[:result]

    end

    def fetch_data(url)
      begin
        response = execute_request(url)
      rescue Exception => e
        Log.error(e)
        return nil
      end
      begin
        parsed_response = JSON.parse(response.body, :symbolize_names => true)
      rescue JSON::ParserError
        Log.error("Invalid response from the server for [#{url}] [#{response.body}]")
        return nil
      end
      parsed_response
    end

    def execute_request(url)
      uri = URI.parse url

      request = Net::HTTP::Get.new(uri.path)
      if @configuration[:login]
        request.basic_auth @configuration[:login], @configuration[:password] #extended to parse username/password
      end

      request_params = {}
      if uri.scheme == 'https'
        request_params[:use_ssl] = true
        request_params[:verify_mode] = OpenSSL::SSL::VERIFY_NONE 
      end

      Net::HTTP.start(uri.host, uri.port, request_params) { |http| http.request(request) }
    end

  end


end
