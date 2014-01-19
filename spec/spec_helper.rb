require 'heroploy/heroku_commands'
require 'heroploy/git_commands'
require 'support/shell_support'

RSpec.configure do |config|
  config.color_enabled = true
  
  config.include ShellSupport
end
