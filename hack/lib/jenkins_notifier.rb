require NSBundle.mainBundle.pathForResource("notifier", ofType:"rb")
require NSBundle.mainBundle.pathForResource("jenkins_api", ofType:"rb")
DEFAULT_CONFIGURATION_FILE = NSBundle.mainBundle.pathForResource("configuration", ofType:"yml")


framework 'foundation'


module JenkinsNotifier

  class JenkinsNotifier

    def start
        
        configuration_relative_path = DEFAULT_CONFIGURATION_FILE
        
        configuration_path = File.expand_path(configuration_relative_path, File.dirname(__FILE__))
        
        
        configuration = YAML.load_file(configuration_path)
        puts "called"

      unless configuration[:server_url]
        Log.error "No server_url configured"
        exit -1
      end

      notifier_type = configuration[:notifier] || 'autodetect'
      Log.debug "Notifier is [#{notifier_type}]"
      Notifier.create notifier_type

      begin
        @jenkins_api = JenkinsApi.new(configuration)
      rescue JenkinsException => e
        puts "EXCEPTION!"
        exit -1
      rescue Exception => e
        puts "EXCEPTION!"

        Log.error e.class
        Log.error e
        exit -1
      end

      fetch_delay = (configuration[:fetch_delay] || 60).to_i
      while true
        sleep fetch_delay
        Log.debug 'Fetching job statuses'
        @jenkins_api.fetch_jobs
      end
    end

  end

  class JenkinsException < RuntimeError

  end

end