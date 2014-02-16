require 'spec_helper'

describe Heroploy::Config::Environment do
  let(:env_name) { 'production' }

  describe "#initialize" do
    context "it initializes the accessors" do
      let(:remote_name) { 'my-remote' }
      let(:app_name) { 'my-app' }
      let(:tag) { 'my-tag' }
      let(:variables) { {'my-var' => 'some-value'} }
      let(:attrs) { {'remote' => remote_name, 'app' => app_name, 'tag' => tag, 'variables' => variables} }
      
      subject(:environment) { Heroploy::Config::Environment.new(env_name, attrs) }

      its(:name) { should eq(env_name) }
      its(:remote) { should eq(remote_name) }
      its(:app) { should eq(app_name) }
      its(:tag) { should eq(tag) }
      its(:variables) { should eq(variables) }
      its(:checks) { should be_instance_of(Heroploy::Config::EnvironmentChecks) }      
    end
    
    context "if no remote name is given" do
      subject(:environment) { Heroploy::Config::Environment.new(env_name, {}) }
      
      it "uses the environment name for the remote" do
        expect(environment.remote).to eq(env_name)
      end
    end
  end
end
