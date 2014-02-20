require 'spec_helper'

describe Heroploy::Config::EnvironmentChecks do
  describe "#initialize" do
    context "it initializes the accessors" do
      let(:pushed) { true }
      let(:branch_name) { 'my-branch' }
      let(:staging_env_name) { 'my-staging-environment' }
      let(:travis) { true }
      let(:attrs) { {'pushed' => pushed, 'branch' => branch_name, 'staged' => staging_env_name, 'travis' => travis} }
      
      subject(:environment_checks) { Heroploy::Config::EnvironmentChecks.new(attrs) }

      its(:pushed) { should eq(pushed) }
      its(:branch) { should eq(branch_name) }
      its(:staged) { should eq(staging_env_name) }
      its(:travis) { should eq(travis) }
    end
    
    context "if no staging environment name is given" do
      subject(:environment_checks) { Heroploy::Config::EnvironmentChecks.new({'staged' => true}) }
      
      it "assumes the staging environment is called 'staging'" do
        expect(environment_checks.staged).to eq('staging')
      end
    end
  end
end
