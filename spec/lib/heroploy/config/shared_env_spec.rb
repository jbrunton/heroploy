require 'spec_helper'

describe Heroploy::Config::SharedEnv do
  describe "#initialize" do
    context "it initializes the accessors" do
      let(:variables) { {'my-var' => 'some-value'} }
      let(:required) { ['my-var'] }
      let(:attrs) { {'required' => required, 'variables' => variables} }
      
      subject(:shared_env) { Heroploy::Config::SharedEnv.new(attrs) }

      its(:required) { should eq(required) }
      its(:variables) { should eq(variables) }
    end    
  end
end
