module JenkinsNotifier

  module Notifier

    def Notifier.create(instance_type)
      ::JenkinsNotifier::Log.info "Will use #{instance_type} notifier"
      case instance_type
        when 'memory'
          require  NSBundle.mainBundle.pathForResource("memory_notifier", ofType:"rb") 
          @notifier = Notifier::MemoryNotifier.new
        when 'console'
          require NSBundle.mainBundle.pathForResource("console_notifier", ofType:"rb")
          @notifier = Notifier::ConsoleNotifier.new
        when 'mac_os'
          require  NSBundle.mainBundle.pathForResource("mac_os_notifier", ofType:"rb")
          @notifier = Notifier::MacOsNotifier.new
          @notifier.init
        when 'autodetect'
          Notifier.autodetect
        else
          raise "Unknown notifier [#{instance_type}]"
      end
    end

    def Notifier.notify(message, url = null)
      @notifier.notify(message, url)
    end

    def Notifier.notify_execution(job, display_name, result, url, duration, last_execution)
      @notifier.notify_execution(job, display_name, result, url, duration, last_execution)
    end

    private

    def Notifier.autodetect

      begin
        
        Notifier.create('mac_os')
        return
      rescue LoadError
      end
      Notifier.create('console')

    end

  end

end