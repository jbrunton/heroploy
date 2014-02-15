require 'heroploy/commands/shell'

module Heroploy
  module Commands
    module Heroku
      def heroku_exec(cmd, app_name)
        Bundler.with_clean_env do
          Shell.exec "heroku #{cmd} --app #{app_name}"
        end
      end
  
      def heroku_run(cmd, app_name)
        heroku_exec("run #{cmd}", app_name)
      end
  
      def heroku_migrate(app_name)
        heroku_run("rake db:migrate", app_name)
      end
      
      def heroku_config_set(vars, app_name)
        vars_string = vars.collect.map{|key,value| "#{key}=#{value}"}.join(" ")
        heroku_exec("config:set #{vars_string}", app_name)
      end
    end
  end
end
