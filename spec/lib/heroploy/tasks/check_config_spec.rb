require 'spec_helper'

describe "check:config" do
  let(:env_vars) {
    puts "*** generating env_vars"
    env_vars = build(:env_vars)
    puts "*** env_vars: #{env_vars}"
    env_vars
  }
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes :check_config" do
    expect_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:check_config).with(env_vars)
    task.invoke
  end
end
