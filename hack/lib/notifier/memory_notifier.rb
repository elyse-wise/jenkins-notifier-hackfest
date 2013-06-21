module JenkinsNotifier

  module Notifier

    # Store messages in memory, handy for testing
    class MemoryNotifier

      attr_reader :messages

      def initialize
        @messages = []
      end

      def notify(message, url)
        @messages << {:message => message, :url => url}
      end

      def notify_execution(job, display_name, result, url, duration, last_execution)
        @messages << {
        }
      end


    end

  end

end