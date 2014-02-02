module ShellSupport
  def stub_shell
    Heroploy::Shell.stub(:eval).and_return("")
    Heroploy::Shell.stub(:exec)
  end
  
  def expect_command(cmd = nil)
    if cmd.nil?
      expect(Heroploy::Shell).to receive(:exec)
    else
      expect(Heroploy::Shell).to receive(:exec).with(cmd)
    end
  end
  
  def expect_eval(cmd = nil)
    if cmd.nil?
      expect(Heroploy::Shell).to receive(:eval)
    else
      expect(Heroploy::Shell).to receive(:eval).with(cmd)
    end
  end
end
