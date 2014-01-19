module HerokuCommands
  def heroku_exec(cmd, app_name)
    FileUtils.sh "heroku #{cmd} --app #{app_name}"
  end
  
  def heroku_run(cmd, app_name)
    heroku_exec("run #{cmd}", app_name)
  end
  
  def heroku_migrate(app_name)
    Bundler.with_clean_env do
      heroku_run("rake db:migrate", app_name)
    end
  end
end
