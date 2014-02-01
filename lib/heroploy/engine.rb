module Heroploy
  class Engine < ::Rails::Engine
    isolate_namespace Heroploy

    rake_tasks do
      load 'heroploy/tasks/tasks.rake'
    end
  end
end
