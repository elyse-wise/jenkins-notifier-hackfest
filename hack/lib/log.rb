require 'time'

module JenkinsNotifier

  # Logging system
  class Log

    attr_reader :verbose

    def Log.create(verbose)
      @log = Log.new(verbose)
    end

    def Log.debug(message)
      @log.log(:debug, message)
    end

    def Log.info(message)
      @log.log(:info, message)
    end

    def Log.warning(message)
      @log.log(:warning, message)
    end

    def Log.error(message)
      @log.log(:error, message)
    end

    def initialize(verbose)
      @verbose = verbose
    end

    def log(level, message)
      unless (level == :debug) && !verbose
        STDOUT << sprintf("%7s %s %s\n", level.to_s.upcase, Time.now.strftime('%Y-%m-%d %H:%M:%S.%L'), message)
      end
    end

  end

end