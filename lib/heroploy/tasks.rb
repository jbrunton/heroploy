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
  
  deploy_config = DeployConfig.new('.deploy.yml')
  
  deploy_config.apps.each do |app_name, config|
    namespace app_name do
      namespace :check do
        desc "check remote exists for #{app_name}"
        task :remote do
          unless git_remote_exists?(config.remote)
            raise "Could not find remote '#{config.remote}'"
          end
        end
        
        desc "check we can deploy to #{app_name} from the current branch"
        task :branch do
          
        end
        
        desc "check the changes have already been staged"
        task :staged do
          
        end
        
        desc "do all the checks for #{app_name}"
        task :all => [:remote, :branch, :staged]
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
