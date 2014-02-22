require 'spec_helper'

describe "check:travis" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes :check_travis" do
    Heroploy::Tasks::CheckTaskLib.any_instance.stub(:current_branch).and_return("my-branch")
    
    expect_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:check_travis)
      .with("my-branch", "my-travis-user/my-travis-repo")
    
    task.invoke
  end
end
