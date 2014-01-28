require 'rake/tasklib'

require 'heroploy/commands/heroku'
require 'heroploy/commands/git'
require 'heroploy/commands/checks'

require 'heroploy/config/deploy_config'
require 'heroploy/tasks/env_task_lib'

module Heroploy
  class DeployTaskLib < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)
    
    attr_accessor :deploy_config
    
    def initialize(deploy_config)
      @deploy_config = deploy_config
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
      deploy_config.environments.each do |env_config|
        EnvTaskLib.new(deploy_config, env_config)
      end
    end
  end
end
