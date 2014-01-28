require 'coveralls'
Coveralls.wear!('rails')

require 'factory_girl'

require 'heroploy'
require 'heroploy/tasks/deploy_task_lib'

require 'support/shell_support'
require 'support/shared_contexts/rake'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.color_enabled = true
  
  config.include FactoryGirl::Syntax::Methods
  
  config.include ShellSupport
end
