describe "check:pushed" do
  let(:environment) { build(:env_config, :production) }
  include_context "rake"
  
  it "invokes :check_pushed" do
    Heroploy::CheckTaskLib.any_instance.stub(:current_branch).and_return("my-branch")
    expect_any_instance_of(Heroploy::CheckTaskLib).to receive(:check_pushed).with("my-branch")
    task.invoke
  end
end
