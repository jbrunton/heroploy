require 'heroploy'
require 'heroploy/heroku_commands'
require 'heroploy/git_commands'
require 'heroploy/config/deploy_config'
require 'heroploy/rake_task'
require 'support/shell_support'
require 'support/shared_contexts/rake'

RSpec.configure do |config|
  config.color_enabled = true
  
  config.include ShellSupport
end
