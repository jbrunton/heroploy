require 'spec_helper'

describe Heroploy::Config::EnvVars do
  describe "#initialize" do
    context "it initializes the accessors" do
      let(:required_vars) { ['my-var'] }
      let(:common_vars) { { 'my-var' => 'some-value' } }
      let(:attrs) { {'required' => required_vars, 'common' => common_vars } }
      
      subject(:env_vars) { Heroploy::Config::EnvVars.new(attrs) }

      its(:required) { should eq(required_vars) }
      its(:common) { should eq(common_vars) }
    end    
  end
end
