require 'spec_helper'

describe Heroploy::Commands::Rails do
  before(:each) do
    stub_shell
  end
  
  let(:commands) { Object.new.extend(Heroploy::Commands::Rails) }
  
  describe "#rails_server" do
    it "starts a rails server" do
      expect_command("bundle exec rails s")
      commands.rails_server({}, {})
    end
    
    it "passes the given variables to the rails environment" do
      local_variables = {'foo' => 'bar'}
      shared_variables = {'fizz' => 'buzz'}
      expect_command("fizz=buzz foo=bar bundle exec rails s")
      commands.rails_server(shared_variables, local_variables)
    end
  end  
end
