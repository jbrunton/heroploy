require 'rake/tasklib'

module Heroploy
  class Shell
    extend FileUtils

    def self.eval(cmd)
      `#{cmd}`
    end

    def self.exec(cmd)
      sh cmd
    end
  end
end
