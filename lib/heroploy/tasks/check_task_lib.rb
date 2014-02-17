require 'rake/tasklib'

require 'heroploy/commands/heroku'
require 'heroploy/commands/git'
require 'heroploy/commands/checks'

module Heroploy
  module Tasks
    class CheckTaskLib < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)
    
      include Commands::Git
      include Commands::Heroku
      include Commands::Checks
    
      attr_accessor :deploy_config
      attr_accessor :env_config
      attr_accessor :defined_tasks
    
      def initialize(deploy_config, env_config)
        @deploy_config = deploy_config
        @env_config = env_config
        @defined_tasks = []
        define      
      end
    
      def define
        define_remote_check
        define_pushed_check
        define_branch_check
        define_staged_check
        define_config_check
        define_all_check
      end
    
      def define_remote_check
        desc "check remote exists for #{env_config.name}"
        task :remote do
          remote = env_config.remote
          check_remote(remote)
        end
      
        @defined_tasks << :remote
      end
    
      def define_pushed_check
        if env_config.checks.pushed then
          desc "check changes have been pushed to origin"
          task :pushed do
            check_pushed(current_branch)
          end
          @defined_tasks << :pushed
        end
      end
    
      def define_branch_check
        if env_config.checks.branch then
          desc "check we can deploy to #{env_config.name} from the current branch"
          task :branch do
            valid_branch = env_config.checks.branch
            check_branch(current_branch, valid_branch, env_config.name)
          end
          @defined_tasks << :branch
        end
      end
    
      def define_staged_check
        if env_config.checks.staged then
          desc "check the changes have already been staged"
          task :staged do
            staging_env_config = deploy_config[env_config.checks.staged]
            check_staged(staging_env_config.remote, current_branch, staging_env_config.name)
          end
          @defined_tasks << :staged
        end
      end
      
      def define_config_check
        desc "check all required config variables are defined"
        task :config => :load_remote_configs do
          check_config(deploy_config.shared_env, env_config)
        end
        @defined_tasks << :config
      end
    
      def define_all_check
        desc "do all the checks for #{env_config.name}"
        task :all => @defined_tasks
      end
    end
  end
end
