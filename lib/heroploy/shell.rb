class Shell
  def self.eval(cmd)
    `#{cmd}`
  end
end
