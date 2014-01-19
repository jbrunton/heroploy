describe "check:branch" do
  include_context "rake"
  
  context "if checks.branch is set" do
    before { environment.checks.stub(:branch).and_return("master") }

    it "invokes :check_branch" do
      tasklib.stub(:current_branch).and_return("my-branch")
      expect(tasklib).to receive(:check_branch).with("my-branch", "master", "production")
      task.invoke
    end
  end
  
  context "if checks.branch is nil" do
    before { environment.checks.stub(:branch).and_return(nil) }

    it "doesn't invoke :check_branch" do
      expect(tasklib).to receive(:check_branch).exactly(0).times
      task.invoke
    end
  end
end
