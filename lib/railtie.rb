require 'rails'

module Heroploy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'heroploy/tasks/tasks.rake'
    end
  end
end
