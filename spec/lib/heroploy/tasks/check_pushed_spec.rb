describe "check:pushed" do
  include_context "rake"
  
  context "if checks.pushed is true" do
    before { environment.checks.stub(:pushed).and_return(true) }

    it "invokes :check_pushed" do
      tasklib.stub(:current_branch).and_return("my-branch")
      expect(tasklib).to receive(:check_pushed).with("my-branch")
      task.invoke
    end
  end
  
  context "if checks.pushed is false" do
    before { environment.checks.stub(:pushed).and_return(false) }

    it "doesn't invoke :check_pushed" do
      expect(tasklib).to receive(:check_pushed).exactly(0).times
      task.invoke
    end
  end
end
