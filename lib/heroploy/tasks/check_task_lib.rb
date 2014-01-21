require 'rake/tasklib'

require 'heroploy/commands/heroku'
require 'heroploy/commands/git'
require 'heroploy/commands/checks'

require 'heroploy/config/deploy_config'

module Heroploy
  class CheckTaskLib < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)
    
    include Commands::Git
    include Commands::Heroku
    include Commands::Checks
    
    def initialize(deploy_config, env_config)
      desc "check remote exists for #{env_config.name}"
      task :remote do
        remote = env_config.remote
        check_remote(remote)
      end
      
      all_tasks = [:remote]

      if env_config.checks.pushed then
        desc "check changes have been pushed to origin"
        task :pushed do
          check_pushed(current_branch)
        end
      end

      if env_config.checks.branch then
        desc "check we can deploy to #{env_config.name} from the current branch"
        task :branch do
          valid_branch = env_config.checks.branch
          check_branch(current_branch, valid_branch, env_config.name)
        end
        all_tasks << :branch
      end

      if env_config.checks.staged then
        desc "check the changes have already been staged"
        task :staged do
          staging_env_config = deploy_config[env_config.checks.staged]
          check_staged(staging_env_config.remote, current_branch, staging_env_config.name)
        end
        all_tasks << :staged
      end

      desc "do all the checks for #{env_config.name}"
      task :all => all_tasks
    end
  end
end
