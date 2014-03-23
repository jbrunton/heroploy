require 'spec_helper'

describe "run" do
  let(:local_variables) { {'foo' => 'bar'} }
  let(:shared_variables) { {'fizz' => 'buzz'} }

  let(:shared_env) { build(:shared_env, variables: shared_variables) }
  let(:local_env) { build(:environment, :local, variables: local_variables) }

  let(:deployment_config) { build(:deployment_config, shared_env: shared_env, environments: [local_env]) }

  include_context "rake"
  
  it "invokes rails_server" do
    expect_any_instance_of(Heroploy::Tasks::EnvTaskLib).to receive(:rails_server)
      .with(shared_variables, local_variables)
    
    task.invoke
  end
end
