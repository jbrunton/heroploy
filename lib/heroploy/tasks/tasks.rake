require 'heroploy/tasks/deploy_task_lib'

namespace :heroploy do
  deploy_config = DeployConfig.load  
  Heroploy::DeployTaskLib.new(deploy_config)
end
