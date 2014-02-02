describe "check:remote" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes :check_remote" do
    expect_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:check_remote).with("production")
    task.invoke
  end
end
