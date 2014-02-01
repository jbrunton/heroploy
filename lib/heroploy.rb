require "rails"

require "heroploy/version"
require "heroploy/engine" if defined?(Rails) && Rails::VERSION::MAJOR >= 3

module Heroploy
  def self.root
    Pathname.new(File.expand_path '../..', __FILE__)
  end
end
