require "rails"

require "heroploy/version"
require "heroploy/engine" if defined?(Rails) && Rails::VERSION::MAJOR >= 3

module Heroploy
  # The root path of the Heroploy gem on the file system
  #
  # @return [Pathname] the root path of the gem
  def self.root
    Pathname.new(File.expand_path '../..', __FILE__)
  end
end
