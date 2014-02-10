require 'heroploy/config/deployment_config'
require 'heroploy/config/environment'
require 'heroploy/config/env_vars'

module Heroploy
  module Config
    class DeploymentConfig
      attr_accessor :environments
      attr_accessor :variables

      def [](env_name)
        environments.select{ |env| env.name == env_name }.first
      end

      def initialize(attrs = {})
        unless attrs['environments'].nil?
          @environments = attrs['environments'].map { |name, attrs| Environment.new(name, attrs) }
        end
        unless attrs['variables'].nil?
          @variables = EnvVars.new(attrs['variables'])
        end
      end
  
      def self.load
        DeploymentConfig.new(YAML::load(File.open('config/heroploy.yml')))
      end
    end
  end
end
