module JenkinsNotifier

  module Notifier

    # Console notifier, use the Log class
    class ConsoleNotifier

      def notify(message, url)
        if url
          ::JenkinsNotifier::Log.info "#{message} #{url}"
        else
          ::JenkinsNotifier::Log.info message
        end
      end

      def notify_execution(job, display_name, result, url, duration, last_execution)
        message = "#{display_name} #{result.downcase} #{url} duration #{duration}"
        if last_execution
          message << ", last execution was #{last_execution.downcase}"
        end
        ::JenkinsNotifier::Log.info message
      end

    end
  end

end