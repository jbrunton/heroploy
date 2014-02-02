require 'rake/tasklib'

require 'heroploy/commands/git'
require 'heroploy/tasks/env_task_lib'

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
        define_env_tasks
      end
    
      def define_fetch_task
        desc 'do a git fetch'
        task :fetch do
          git_fetch
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
