require 'rake/tasklib'

require 'heroploy/commands/git'
require 'heroploy/tasks/env_task_lib'
require 'heroploy/config/deployment_config'

module Heroploy
  module Tasks
    class DeployTaskLib < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)
      include Commands::Git
    
      attr_accessor :deployment_config
    
      def initialize(deployment_config)
        @deployment_config = deployment_config
        define
      end

      def define
        define_fetch_task
        define_load_configs_task
        define_env_tasks
      end
    
      def define_fetch_task
        desc 'do a git fetch'
        task :fetch do
          git_fetch
        end
      end
      
      def define_load_configs_task
        desc 'load remote configs'
        task :load_remote_configs do
          unless deployment_config.remote_configs.nil?
            deployment_config.remote_configs.each do |remote_config|
              git_clone(remote_config.repository, remote_config.name) do
                remote_config.files.each do |filename|
                  config_file = File.join(Dir.pwd, remote_config.name, filename)
                  deployment_config.merge_config(Heroploy::Config::DeploymentConfig.load(config_file))
                end
              end
            end
          end
        end
      end
    
      def define_env_tasks
        deployment_config.environments.each do |env|
          EnvTaskLib.new(deployment_config, env)
        end
      end
    end
  end
end
