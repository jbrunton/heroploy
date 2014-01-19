require "heroploy/version"
require File.join(File.dirname(__FILE__), 'railtie.rb') if defined?(Rails) && Rails::VERSION::MAJOR >= 3

module Heroploy
  def self.root
    Pathname.new(File.expand_path '../..', __FILE__)
  end
end
