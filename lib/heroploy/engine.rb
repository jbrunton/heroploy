require 'rails'

module Heroploy
  class Engine < ::Rails::Engine
    rake_tasks do
      load 'heroploy/tasks/tasks.rake'
    end
  end
end
