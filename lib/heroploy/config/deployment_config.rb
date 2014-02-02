require 'heroploy/config/deployment_config'
require 'heroploy/config/environment'

module Heroploy
  module Config
    class DeploymentConfig
      # A list of the environments defined by the configuration file
      # @return [Array<Environment>]
      attr_accessor :environments
  
      # Returns the {Environment} instance for the given name, or nil if none is found
      #
      # @param env_name [String] the name of the {Environment} to return
      # @return [Environment, nil] the {Environment} instance with the given name, or nil if none is found
      def [](env_name)
        environments.select{ |env| env.name == env_name }.first
      end
  
      # Initializes {#environments} with an {Environment} instance for each specified environment in the given hash
      #
      # @param attrs [Hash] YAML representation of the deployment configuration
      def initialize(attrs = {})
        unless attrs['environments'].nil?
          @environments = attrs['environments'].map { |name, attrs| Environment.new(name, attrs) }
        end
      end
  
      # Instantiates and returns a new instance of {DeploymentConfig DeploymentConfig} initialized with the YAML config file found at 'config/heroploy.yml'
      #
      # @return [DeploymentConfig]
      def self.load
        DeploymentConfig.new(YAML::load(File.open('config/heroploy.yml')))
      end
    end
  end
end
