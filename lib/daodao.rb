$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

# rubygems
require 'rubygems'

# stdlib
require 'fileutils'
require 'time'
require 'English'
require 'pathname'
require 'logger'

module DaoDao
  autoload :LogAdapter,            'daodao/log_adapter'
  autoload :VERSION,               'daodao/version'
  autoload :Configuration,         'daodao/configuration'
  autoload :Errors,                'daodao/errors'
  autoload :HttpRequester,         'daodao/utils/http_requester'
  autoload :City,                  'daodao/model/city'
  autoload :Hotel,                 'daodao/model/hotel'
  autoload :Room,                  'daodao/model/room'
  autoload :Utility,               'daodao/utils/utility'
  autoload :Database,              'daodao/database'

  # crawler and indexer
  require 'daodao/crawler'
  require 'daodao/indexer'

  class << self
    def env
      ENV['DAODAO_ENV'] || 'development'
    end

    # Public: Generate a DaoDao configuration Hash by merging the default
    # options with anything in _config.yml, and adding the given options on top.
    #
    # override - A Hash of config directives that override any options in both
    #            the defaults and the config file. See DaoDao::Configuration::DEFAULTS for a
    #            list of option names and their defaults.
    #
    # Returns the final configuration Hash.
    def configuration(override = Hash.new)
      config = Configuration[Configuration::DEFAULTS]
      override = Configuration[override].stringify_keys
      unless override.delete('skip_config_files')
        config = config.read_config_files(config.config_files(override))
      end

      # Merge DEFAULTS < _config.yml < override
      config = Utility.deep_merge_hashes(config, override).stringify_keys

      config
    end

    # Public: Fetch the logger instance.
    #
    # Returns the LogAdapter instance.
    def logger
      @logger ||= LogAdapter.new(Stevenson.new, (ENV["DAODAO_LOG_LEVEL"] || :info).to_sym)
    end

    # Public: Set the log writer.
    #         New log writer must respond to the same methods
    #         as Ruby's interal Logger.
    #
    # writer - the new Logger-compatible log transport
    #
    # Returns the new logger.
    def logger=(writer)
      @logger = LogAdapter.new(writer)
    end
  end
end
