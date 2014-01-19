require 'heroploy/heroku_commands'

module ShellSupport
  def expect_command(cmd)
    expect(FileUtils).to receive(:sh).with(cmd)
  end
end

RSpec.configure do |config|
  config.color_enabled = true
  
  config.include ShellSupport
end
