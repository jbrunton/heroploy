require 'heroploy'
require 'factory_girl'
require 'travis'

require 'cucumber/rspec/doubles'

require 'heroploy/config/deployment_config'
require 'heroploy/tasks/deploy_task_lib'

FactoryGirl.find_definitions

World(FactoryGirl::Syntax::Methods)

Before do
  allow(Heroploy::Shell).to receive(:eval).and_return("")
  allow(Heroploy::Shell).to receive(:exec)
end


