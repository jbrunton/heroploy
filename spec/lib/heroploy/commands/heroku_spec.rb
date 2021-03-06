require 'spec_helper'

describe Heroploy::Commands::Heroku do
  before(:each) do
    stub_shell
  end
  
  let(:commands) { Object.new.extend(Heroploy::Commands::Heroku) }
  
  context "#heroku_exec" do
    it "executes the heroku command for the given app" do
      expect_command("heroku help --app my-app")
      commands.heroku_exec("help", "my-app")
    end
  end
  
  context "#heroku_run" do
    it "runs the given command on the heroku server" do
      expect_command("heroku run rake db:migrate --app my-app")
      commands.heroku_run("rake db:migrate", "my-app")
    end
  end
  
  context "#heroku_config_set" do
    it "sets the values for the given config variables" do
      common_vars = {'foo' => 'foo'}
      env_vars = {'bar' => 'bar'}
      expect_command("heroku config:set foo=foo bar=bar --app my-app")
      commands.heroku_config_set(common_vars, env_vars, "my-app")
    end
  end
  
  context "#heroku_db_migrate" do
    it "runs rake db:migrate on the heroku server" do
      expect_command("heroku run rake db:migrate --app my-app")
      commands.heroku_db_migrate("my-app")
    end    
  end
  
  describe "#heroku_db_reset" do
    it "resets the database for the given app" do
      expect_command("heroku pg:reset DATABASE --confirm my-app --app my-app")
      commands.heroku_db_reset("my-app")
    end
  end
  
  describe "#heroku_db_seed" do
    it "seeds the database for the given app" do
      expect_command("heroku run rake db:seed --app my-app")
      commands.heroku_db_seed("my-app")
    end
  end
end
