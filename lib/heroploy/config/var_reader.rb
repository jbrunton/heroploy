require 'heroploy/config/deployment_config'

module Heroploy
  module Config
    class VarReader
      attr_accessor :deployment_config
      
      def deployment_config
        @deployment_config ||= begin
          config = Heroploy::Config::DeploymentConfig.load
          config.load_remotes!
          config
        end
      end
      
      def env_matcher_name
        "Rails.env[#{Rails.env}]"
      end
      
      def [](var_name)
        config_var = ENV[var_name.to_s]
        config_var ||= deployment_config[env_matcher_name].variables[var_name.to_s]
        config_var ||= deployment_config.shared_env.variables[var_name.to_s]
      end
    end
  end
  
  def self.config_vars
    @config_vars ||= Config::VarReader.new
  end
end
