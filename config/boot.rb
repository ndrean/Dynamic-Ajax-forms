ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# speed up boot time by caching expensive operations.
# require 'bootsnap/setup' if ENV.fetch("ENABLE_BOOTSNAP", "true") == "true"
require 'pg_search'
