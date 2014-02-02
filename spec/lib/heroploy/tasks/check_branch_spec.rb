describe "check:branch" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes :check_branch" do
    Heroploy::Tasks::CheckTaskLib.any_instance.stub(:current_branch).and_return("my-branch")
    expect_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:check_branch).with("my-branch", "master", "production")
    task.invoke
  end
end
