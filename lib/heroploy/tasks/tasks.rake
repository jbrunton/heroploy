require 'heroploy/config/deployment_config'
require 'heroploy/tasks/deploy_task_lib'

namespace :heroploy do
  begin
    deployment_config = Heroploy::Config::DeploymentConfig.load  
    Heroploy::DeployTaskLib.new(deployment_config)
  rescue Errno::ENOENT
    puts "Warning: no config file present for Heroploy.  Run 'rails generate heroploy:install' or add a heroploy.yml file to your project."
  end
end
