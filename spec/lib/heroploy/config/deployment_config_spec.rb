require 'spec_helper'

describe Heroploy::Config::DeploymentConfig do
  before(:each) { stub_shell }
  
  let(:attrs) do
    {
      'environments' => {'staging' => {}, 'production' => {}},
      'variables' => {
        'required' => ['my-var'],
        'common' => {'my-var' => 'some-value'}
      }
    }
  end
  
  subject(:deployment_config) { Heroploy::Config::DeploymentConfig.new(attrs) }
  
  context "#initialize" do
    context "it initializes its environments" do
      its(:environments) { should include an_environment_named(:staging) }
      its(:environments) { should include an_environment_named(:production) }
    end
    
    context "its initializes its environment variables" do
      its('variables.required') { should eq(['my-var']) }
      its('variables.common') { should eq({'my-var' => 'some-value'}) }
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
      variables:
        required:
          - my-var
        common:
          my-var: some-value
      environments:
        heroku:
          app: my-app
      END
    end
    
    before { File.stub(:open).with('config/heroploy.yml').and_return(yaml_config) }
    
    let(:deployment_config) { deployment_config = Heroploy::Config::DeploymentConfig.load }
    
    it "it initializes the list of environments" do
      expect(deployment_config.environments).to include an_environment_named(:heroku)
    end
    
    it "initializes the environment variables" do
      expect(deployment_config.variables.required).to eq(['my-var'])
      expect(deployment_config.variables.common).to eq({ 'my-var' => 'some-value' })
    end
  end
end
