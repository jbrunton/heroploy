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
  
  context "#heroku_migrate" do
    it "runs rake db:migrate on the heroku server" do
      expect_command("heroku run rake db:migrate --app my-app")
      commands.heroku_migrate("my-app")
    end    
  end
  
  context "#heroku_config_set" do
    it "sets the value for the given config variable" do
      expect_command("heroku config:set foo=bar --app my-app")
      commands.heroku_config_set({"foo" => "bar"}, "my-app")
    end
  end
end
