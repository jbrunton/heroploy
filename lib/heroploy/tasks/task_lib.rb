require 'rake/tasklib'

require 'heroploy/commands/heroku'
require 'heroploy/commands/git'
require 'heroploy/commands/checks'

require 'heroploy/config/deploy_config'

module Heroploy
  class TaskLib < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)
    
    include Commands::Git
    include Commands::Heroku
    include Commands::Checks
    
    attr_accessor :config
    
    def initialize(deploy_config)
      @config = deploy_config
      
      deploy_config.environments.each do |env_config|
        
        namespace env_config.name do
          namespace :check do
            desc "check remote exists for #{env_config.name}"
            task :remote do
              remote = env_config.remote
              check_remote(remote)
            end

            desc "check changes have been pushed to origin"
            task :pushed do
              if env_config.checks.pushed then
                check_pushed(current_branch)
              end
            end

            desc "check we can deploy to #{env_config.name} from the current branch"
            task :branch do
              if env_config.checks.branch then
                valid_branch = env_config.checks.branch
                check_branch(current_branch, valid_branch, env_config.name)
              end
            end

            desc "check the changes have already been staged"
            task :staged do
              if env_config.checks.staged then
                staging_env_config = deploy_config.environments[env_config.checks.staged]
                check_staged(staging_env_config.remote, current_branch, staging_env_config.name)
              end
            end

            desc "do all the checks for #{env_config.name}"
            task :all => [:remote, :pushed, :branch, :staged]
          end

          desc "push the current branch to master on #{env_config.name}"
          task :push do
            git_push_to_master(env_config.remote, current_branch)
          end

          desc "run database migrations on #{env_config.name}"
          task :migrate do
            heroku_migrate(env_config.heroku)
          end

          desc "tag the deployment to #{env_config.name}"
          task :tag do
            if env_config.tag then
              tag = DateTime.now.strftime(env_config.tag)
              git_tag(tag, "Deployed #{current_branch} to #{env_config.name}")
              git_push_tag(tag)
            end
          end

          desc "deploy to #{env_config.name}"
          task :deploy => ['check:all', :push, :migrate, :tag]
        end
      end
    end
  end
end
