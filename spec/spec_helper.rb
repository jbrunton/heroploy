require 'coveralls'
Coveralls.wear! do
  add_filter '/spec/'
  add_filter 'lib/heroploy/engine.rb'
end
    
require 'factory_girl'
require 'rails/generators'

require "generator_spec/test_case"
require "generator_spec/matcher"

require 'heroploy'
require 'heroploy/tasks/deploy_task_lib'
require 'heroploy/config/deployment_config'
require 'heroploy/config/environment'
require 'heroploy/config/environment_checks'

require 'support/shell_support'
require 'support/shared_contexts/rake'
require 'support/shared_contexts/generator'

require 'support/customer_matchers/environment_matcher'

FactoryGirl.find_definitions

TMP_ROOT = Pathname.new(File.expand_path('../tmp', __FILE__))

RSpec.configure do |config|
  config.color_enabled = true
  
  config.include FactoryGirl::Syntax::Methods
  
  config.include ShellSupport
  config.include CustomMatchers
end


