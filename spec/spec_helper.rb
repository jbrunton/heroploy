require 'heroploy/shell'
require 'heroploy/heroku_commands'
require 'heroploy/git_commands'

module ShellSupport
  def expect_command(cmd = nil)
    if cmd.nil?
      expect(FileUtils).to receive(:sh)
    else
      expect(FileUtils).to receive(:sh).with(cmd)
    end
  end
  
  def expect_eval(cmd = nil)
    if cmd.nil?
      expect(Shell).to receive(:eval)
    else
      expect(Shell).to receive(:eval).with(cmd)
    end
  end
end

RSpec.configure do |config|
  config.color_enabled = true
  
  config.include ShellSupport
end
