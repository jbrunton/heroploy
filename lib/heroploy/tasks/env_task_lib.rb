require 'rake/tasklib'

require 'heroploy/commands/heroku'
require 'heroploy/commands/git'
require 'heroploy/commands/checks'

require 'heroploy/config/deploy_config'
require 'heroploy/tasks/check_task_lib'

module Heroploy
  class EnvTaskLib < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)
    
    include Commands::Git
    include Commands::Heroku
    include Commands::Checks
    
    attr_accessor :deploy_config
    attr_accessor :env_config
    
    def initialize(deploy_config, env_config)
      @deploy_config = deploy_config
      @env_config = env_config
      define
    end

    def define
      namespace env_config.name do
        define_check_tasks
        define_git_tasks
        define_heroku_tasks
      end
    end
    
    def define_check_tasks
      namespace :check do
        CheckTaskLib.new(deploy_config, env_config)
      end
    end
    
    def define_git_tasks
      desc "push the current branch to master on #{env_config.name}"
      task :push do
        git_push_to_master(env_config.remote, current_branch)
      end

      desc "tag the deployment to #{env_config.name}"
      task :tag do
        if env_config.tag then
          tag = DateTime.now.strftime(env_config.tag)
          git_tag(tag, "Deployed #{current_branch} to #{env_config.name}")
          git_push_tag(tag)
        end
      end
    end
    
    def define_heroku_tasks
      desc "run database migrations on #{env_config.name}"
      task :migrate do
        heroku_migrate(env_config.heroku)
      end

      desc "deploy to #{env_config.name}"
      task :deploy => ['check:all', :push, :migrate, :tag]
    end
  end
end
