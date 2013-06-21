require 'bundler/setup'

require 'yaml'
require_relative 'lib/log'
require_relative 'lib/jenkins_notifier'
DEFAULT_CONFIGURATION_FILE = 'configuration.yml'

verbose = ARGV.include?('-verbose')

JenkinsNotifier::Log.create(verbose)

configuration_relative_path = ARGV.find{|v| v != '-verbose' } || DEFAULT_CONFIGURATION_FILE

configuration_path = File.expand_path(configuration_relative_path, File.dirname(__FILE__))

JenkinsNotifier::Log.info "Use configuration file [#{configuration_path}]"

unless File.exist? configuration_path
  abort "Configuration file [#{configuration_path}] not found"
end

configuration = YAML.load_file(configuration_path)

# || {} so it works with empty file for which yaml return false
JenkinsNotifier::JenkinsNotifier.new(configuration || {})
