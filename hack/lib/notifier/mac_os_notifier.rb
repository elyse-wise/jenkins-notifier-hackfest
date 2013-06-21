


module JenkinsNotifier

  module Notifier
      
      module Notification
          module_function
          def send(text, title, one, two, three)
              notification = NSUserNotification.alloc.init
              notification.title = title
              notification.informativeText = text
              
              center = NSUserNotificationCenter.defaultUserNotificationCenter
              center.scheduleNotification(notification)
          end
      end
      
    # Mac OS notifier, use TerminalNotifier gem
    class MacOsNotifier
    
        
      def init
          @queue = Dispatch::Queue.new('NOTIFY')

      end
        
      def notify(message, url)
        if url
            send_notification(message, 'Jenkins Notifier', url, nil, nil)
            puts message
        else
            send_notification(message, 'Jenkins Notifier', nil, nil, nil)
            puts message
        end
      end

      def notify_execution(job, display_name, result, url, duration, last_execution)
        message = "Duration is #{duration}"
        if last_execution
          message << ", last execution was #{last_execution.downcase} ms"
        end
          send_notification(message, 'Jenkins Notifier', url,  "#{display_name} #{(result || '').downcase}", job )
      end
        
      def send_notification(message, title, open, subtitle, group)
           system "/Users/bwitz/bin/terminal-notifier.sh \"#{title}\" \"#{message}\" \"#{subtitle}\" \"#{group}\" \"#{open}\" "
      end
      
    end

  end

end


