require 'heroploy/git_commands'
require 'heroploy/heroku_commands'
require 'heroploy/config/deploy_config'
require 'heroploy/tasks/task_lib'

namespace :heroploy do

  
  desc 'do a git fetch'
  task :fetch do
    git_fetch
  end
  
  deploy_config = DeployConfig.load  
  Heroploy::TaskLib.new(deploy_config)
end
