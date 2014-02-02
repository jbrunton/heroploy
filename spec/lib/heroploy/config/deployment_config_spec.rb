require 'spec_helper'

describe Heroploy::Config::DeploymentConfig do
  before(:each) { stub_shell }
  
  let(:attrs) { {'environments' => {'staging' => {}, 'production' => {}}} }
  
  subject(:deployment_config) { Heroploy::Config::DeploymentConfig.new(attrs) }
  
  context "#initialize" do
    context "it initializes its environments" do
      its(:environments) { should include an_environment_named(:staging) }
      its(:environments) { should include an_environment_named(:production) }
    end
  end
  
  context "#[]" do
    it "returns the environment with the given name, if one exists" do
      expect(deployment_config['staging']).to be_an_environment_named(:staging)
    end
    
    it "returns nil otherwise" do
      expect(deployment_config['development']).to be_nil
    end
  end
  
  context ".load" do
    let(:yaml_config) do
      <<-END
      environments:
        heroku:
          app: my-app
      END
    end
    
    it "returns a new instance of DeploymentConfig initialized by the heroploy config file" do
      File.stub(:open).with('config/heroploy.yml').and_return(yaml_config)
      deployment_config = Heroploy::Config::DeploymentConfig.load
      expect(deployment_config.environments).to include an_environment_named(:heroku)
    end
  end
end
