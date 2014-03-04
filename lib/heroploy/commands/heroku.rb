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
  
      def heroku_config_set(shared_vars, env_vars, app_name)
        merged_vars = shared_vars.merge(env_vars)
        vars_string = merged_vars.collect.map{|key,value| "#{key}=#{value}"}.join(" ")
        heroku_exec("config:set #{vars_string}", app_name)
      end
      
      def heroku_db_migrate(app_name)
        heroku_run("rake db:migrate", app_name)
      end
      
      def heroku_db_reset(app_name)
        heroku_exec("pg:reset DATABASE --confirm #{app_name}", app_name)
      end
      
      def heroku_db_seed(app_name)
        heroku_run("rake db:seed", app_name)
      end
    end
  end
end
