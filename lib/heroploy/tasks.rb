require 'heroploy/git_commands'
require 'heroploy/heroku_commands'
require 'heroploy/deploy_config'

namespace :heroploy do
  include GitCommands
  include HerokuCommands
  
  desc 'do a git fetch'
  task :fetch do
    git_fetch
  end
  
  deploy_config = DeployConfig.new('.heroploy.yml')
  
  deploy_config.apps.each do |app_name, config|
    namespace app_name do
      namespace :check do
        desc "check remote exists for #{app_name}"
        task :remote do
          remote = config.remote || app_name
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

        desc "check we can deploy to #{app_name} from the current branch"
        task :branch do
          if config.checks.branch then
            unless current_branch == config.checks.branch
              raise "Cannot deploy branch #{current_branch} to #{app_name}"
            end
          end
        end
        
        desc "check the changes have already been staged"
        task :staged do
          if config.checks.staged then
            staging_app_name = config.checks.staged == true ? 'staging' : config.checks.staged
            unless git_staged?(deploy_config.apps[staging_app_name].remote, current_branch)
              raise "Changes not yet staged on #{app_name}"
            end
          end
        end
        
        desc "do all the checks for #{app_name}"
        task :all => [:remote, :pushed, :branch, :staged]
      end
      
      desc "push the current branch to master on #{app_name}"
      task :push do
        git_push_to_master(config.remote, current_branch)
      end
      
      desc "run database migrations on #{app_name}"
      task :migrate do
        heroku_migrate(config.heroku)
      end

      desc "tag the deployment to #{app_name}"
      task :tag do
        if config.tag then
          tag = DateTime.now.strftime(config.tag)
          git_tag(tag, "Deployed #{current_branch} to #{app_name}")
          git_push_tag(tag)
        end
      end

      desc "deploy to #{app_name}"
      task :deploy => ['check:all', :push, :migrate, :tag]
    end
  end
end
