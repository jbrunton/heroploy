require 'rake/tasklib'

require 'heroploy/commands/heroku'
require 'heroploy/commands/git'
require 'heroploy/commands/checks'
require 'heroploy/commands/rails'

require 'heroploy/tasks/check_task_lib'

module Heroploy
  module Tasks
    class EnvTaskLib < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)
    
      include Commands::Git
      include Commands::Heroku
      include Commands::Checks
      include Commands::Rails
    
      attr_accessor :deployment_config
      attr_accessor :env
    
      def initialize(deployment_config, env)
        @deployment_config = deployment_config
        @env = env
        define
      end

      def define
        namespace env.name do
          if env.name == 'local'
            define_run_task
          else
            define_check_tasks
            define_git_tasks
            define_db_tasks
            define_heroku_tasks
          end
        end
      end
      
      def define_run_task
        task :run do
          rails_server(deployment_config.shared_env.variables, env.variables)
        end
      end
    
      def define_check_tasks
        namespace :check do
          CheckTaskLib.new(deployment_config, env)
        end
      end
    
      def define_git_tasks
        desc "push the current branch to master on #{env.name}"
        task :push do
          git_push_to_master(env.remote, current_branch)
        end

        desc "tag the deployment to #{env.name}"
        task :tag do
          if env.tag then
            tag = DateTime.now.strftime(env.tag)
            git_tag(tag, "Deployed #{current_branch} to #{env.name}")
            git_push_tag(tag)
          end
        end
      end
      
      def define_db_tasks
        namespace :db do
          desc "run database migrations on #{env.name}"
          task :migrate do
            heroku_db_migrate(env.app)
          end
          
          desc "reset the database on #{env.name}"
          task :reset do
            heroku_db_reset(env.app)
          end
          
          desc "seed the database on #{env.name}"
          task :seed do
            heroku_db_seed(env.app)
          end
          
          desc "reset, migrate and seed the database"
          task :recreate => [:reset, :migrate, :seed]
        end
      end
    
      def define_heroku_tasks
        desc "set config variables"
        task :config => :load_remote_configs do
          heroku_config_set(deployment_config.shared_env.variables, env.variables, env.app)
        end

        desc "deploy to #{env.name}"
        task :deploy => ['check:all', :push, :config, 'db:migrate', :tag]
      end
    end
  end
end
