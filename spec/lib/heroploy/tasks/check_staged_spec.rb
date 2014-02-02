describe "check:staged" do
  let(:production) { build(:environment, :production) }
  let(:staging) { build(:environment, :staging, remote: "my-staging-remote") }
  let(:environments) { [production, staging] }
  
  include_context "rake"
  
  context "if checks.staged is set" do
    before { production.checks.staged = 'staging' }

    it "invokes :check_pushed" do
      Heroploy::Tasks::CheckTaskLib.any_instance.stub(:current_branch).and_return("my-branch")

      expect_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:check_staged).with("my-staging-remote", "my-branch", "staging")

      task.invoke
    end
  end
end
