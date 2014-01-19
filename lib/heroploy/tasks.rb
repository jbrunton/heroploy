require 'heroploy/git_commands'
require 'heroploy/heroku_commands'
require 'heroploy/config/deploy_config'

namespace :heroploy do
  include GitCommands
  include HerokuCommands
  
  desc 'do a git fetch'
  task :fetch do
    git_fetch
  end
  
  deploy_config = DeployConfig.new('.heroploy.yml')
  
  deploy_config.environments.each do |env_name, config|
    namespace env_name do
      namespace :check do
        desc "check remote exists for #{env_name}"
        task :remote do
          remote = config.remote
          unless git_remote_exists?(remote)
            raise "Could not find remote '#{remote}'"
          end
        end
        
        desc "check changes have been pushed to origin"
        task :pushed do
          if config.checks.pushed then
            branch_name = current_branch
            unless git_remote_has_branch?('origin', branch_name)
              raise "Branch #{branch_name} doesn't exist in origin"
            end
          
            if git_remote_behind?('origin', branch_name) then
              raise "Branch #{branch_name} is behind origin/#{branch_name}"
            end
          end
        end

        desc "check we can deploy to #{env_name} from the current branch"
        task :branch do
          if config.checks.branch then
            unless current_branch == config.checks.branch
              raise "Cannot deploy branch #{current_branch} to #{env_name}"
            end
          end
        end
        
        desc "check the changes have already been staged"
        task :staged do
          if config.checks.staged then
            unless git_staged?(deploy_config.environments[config.checks.staged].remote, current_branch)
              raise "Changes not yet staged on #{env_name}"
            end
          end
        end
        
        desc "do all the checks for #{env_name}"
        task :all => [:remote, :pushed, :branch, :staged]
      end
      
      desc "push the current branch to master on #{env_name}"
      task :push do
        git_push_to_master(config.remote, current_branch)
      end
      
      desc "run database migrations on #{env_name}"
      task :migrate do
        heroku_migrate(config.heroku)
      end

      desc "tag the deployment to #{env_name}"
      task :tag do
        if config.tag then
          tag = DateTime.now.strftime(config.tag)
          git_tag(tag, "Deployed #{current_branch} to #{env_name}")
          git_push_tag(tag)
        end
      end

      desc "deploy to #{env_name}"
      task :deploy => ['check:all', :push, :migrate, :tag]
    end
  end
end
