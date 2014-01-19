describe "check:remote" do
  include_context "rake"
  
  it "invokes :check_remote" do
    expect(tasklib).to receive(:check_remote).with("production")
    task.invoke
  end
end
