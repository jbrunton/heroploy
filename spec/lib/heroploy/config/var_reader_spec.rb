require 'spec_helper'

describe Heroploy::Config::VarReader do
  subject(:var_reader) { Heroploy::Config::VarReader.new }
  
  describe "deployment_config" do
    let(:expected_config) { build(:deployment_config) }
    before { allow(Heroploy::Config::DeploymentConfig).to receive(:load).and_return(expected_config) }
    
    it "loads and returns the deployment config" do
      expect(var_reader.deployment_config).to eq(expected_config)
    end
    
    it "caches the result" do
      expect(Heroploy::Config::DeploymentConfig).to receive(:load).once
      var_reader.deployment_config
      var_reader.deployment_config
    end
  end

  describe "[]" do
    context "if an environment variable is defined" do
      before { allow(ENV).to receive(:[]).with('foo').and_return('bar') }
  
      it "returns the value of the environment variable" do
        expect(var_reader[:foo]).to eq('bar')
      end
    end
    
    context "if an environment matcher is defined" do
      let(:deployment_config) do
        build(:deployment_config,
          :shared_env => build(:shared_env, :variables => {'fizz' => 'buzz'}),
          :environments => [
            build(:environment,
              :name => 'Rails.env[development]',
              :variables => {'foo' => 'baz'}
            )
          ]
        )
      end
      
      before { allow(Heroploy::Config::DeploymentConfig).to receive(:load).and_return(deployment_config) }
      
      it "returns the variable for the matched environment" do
        expect(var_reader[:foo]).to eq('baz')
      end
      
      it "returns shared environment variables" do
        expect(var_reader[:fizz]).to eq('buzz')
      end
    end
  end  
end
