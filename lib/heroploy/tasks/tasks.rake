require 'heroploy/tasks/deploy_task_lib'

namespace :heroploy do
  begin
    deploy_config = DeployConfig.load  
    Heroploy::DeployTaskLib.new(deploy_config)
  rescue Errno::ENOENT
    puts "Warning: no config file present for Heroploy.  Run 'rails generator heroploy:install' or add a heroploy.yml file to your project."
  end
end
