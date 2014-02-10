require 'spec_helper'

describe Heroploy::Config::EnvironmentChecks do
  describe "#initialize" do
    context "it initializes the accessors" do
      let(:pushed) { true }
      let(:branch_name) { 'my-branch' }
      let(:staging_env_name) { 'my-staging-environment' }
      let(:attrs) { {'pushed' => pushed, 'branch' => branch_name, 'staged' => staging_env_name} }
      
      subject(:environment_checks) { Heroploy::Config::EnvironmentChecks.new(attrs) }

      its(:pushed) { should eq(pushed) }
      its(:branch) { should eq(branch_name) }
      its(:staged) { should eq(staging_env_name) }
    end
    
    context "if no staging environment name is given" do
      subject(:environment_checks) { Heroploy::Config::EnvironmentChecks.new({'staged' => true}) }
      
      it "assumed the staging environment is called 'staging'" do
        expect(environment_checks.staged).to eq('staging')
      end
    end
  end
end
