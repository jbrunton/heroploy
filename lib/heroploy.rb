require "rails"

require "heroploy/version"
require "heroploy/engine" if defined?(Rails) && Rails::VERSION::MAJOR >= 3
require "heroploy/config/var_reader"
