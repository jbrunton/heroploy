describe "check:staged" do
  include_context "rake"
  
  context "if checks.staged is set" do
    before { environment.checks.stub(:staged).and_return("staging") }

    it "invokes :check_pushed" do
      staging_env_config = build(:env_config, name: "staging", remote: "my-staging-remote")
      deploy_config.stub(:[]).with("staging").and_return(staging_env_config)
      tasklib.stub(:current_branch).and_return("my-branch")

      expect(tasklib).to receive(:check_staged).with("my-staging-remote", "my-branch", "staging")

      task.invoke
    end
  end
  
  context "if checks.staged is false" do
    before { environment.checks.stub(:staged).and_return(false) }

    it "doesn't invoke :check_pushed" do
      expect(tasklib).to receive(:check_staged).exactly(0).times
      task.invoke
    end
  end
end
