require 'rails'

module Heroploy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'heroploy/tasks.rb'
    end
  end
end
