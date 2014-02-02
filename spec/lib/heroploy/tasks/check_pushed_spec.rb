describe "check:pushed" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes :check_pushed" do
    Heroploy::Tasks::CheckTaskLib.any_instance.stub(:current_branch).and_return("my-branch")
    expect_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:check_pushed).with("my-branch")
    task.invoke
  end
end
