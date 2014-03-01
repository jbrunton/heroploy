require 'heroploy/config/deployment_config'

module Heroploy
  module Config
    class VarReader
      attr_accessor :deployment_config
      
      def deployment_config
        @deployment_config ||= begin
          config = Heroploy::Config::DeploymentConfig.load
          config.load_remotes! unless config.nil?
          config
        end
      end
      
      def env_matcher_name
        "Rails.env[#{Rails.env}]"
      end
      
      def [](var_name)
        config_var = ENV[var_name.to_s]
        config_var ||= begin
          environment = deployment_config[env_matcher_name]
          environment.variables[var_name.to_s] unless environment.nil?
        end
        config_var ||= begin
          shared_env = deployment_config.shared_env
          shared_env.variables[var_name.to_s] unless shared_env.nil?
        end
      end
    end
  end
  
  def self.config_vars
    @config_vars ||= Config::VarReader.new
  end
end
