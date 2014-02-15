require 'spec_helper'

describe Heroploy::Commands::Checks do
  before(:each) do
    stub_shell
  end
  
  let(:commands) { Object.new.extend(Heroploy::Commands::Checks) }

  describe "#check_remote" do
    it "invokes git_remote_exists? to check the remote" do
      expect(commands).to receive(:git_remote_exists?).with("my-remote").and_return(true)
      commands.check_remote("my-remote")      
    end
    
    context "if the remote exists" do
      before { commands.stub(:git_remote_exists?).with("my-remote").and_return(true) }

      it "executes successfully" do
        commands.check_remote("my-remote")
      end
    end
    
    context "if the remote doesn't exist" do
      before { commands.stub(:git_remote_exists?).with("my-remote").and_return(false) }
      
      it "raises an error" do
        expect{
          commands.check_remote("my-remote")
        }.to raise_error("Could not find remote 'my-remote'")
      end
    end
  end
  
  describe "#check_pushed" do
    context "if the remote branch exists and is up to date" do
      it "executes successfully" do
        expect(commands).to receive(:git_remote_has_branch?).with("origin", "my-branch").and_return(true)
        expect(commands).to receive(:git_remote_behind?).with("origin", "my-branch").and_return(false)
        commands.check_pushed("my-branch")
      end
    end
    
    context "if the remote branch doesn't exist" do
      it "raises an error" do
        commands.stub(:git_remote_has_branch?).with("origin", "my-branch").and_return(false)
        commands.stub(:git_remote_behind?).with("origin", "my-branch").and_return(false)
        expect{
          commands.check_pushed("my-branch")
        }.to raise_error("Branch my-branch doesn't exist in origin")
      end
    end

    context "if the remote branch is behind" do
      it "raises an error" do
        commands.stub(:git_remote_has_branch?).with("origin", "my-branch").and_return(true)
        commands.stub(:git_remote_behind?).with("origin", "my-branch").and_return(true)
        expect{
          commands.check_pushed("my-branch")
        }.to raise_error("Branch my-branch is behind origin/my-branch")
      end
    end
  end
  
  describe "#check_branch" do
    context "if the branch is valid" do
      it "executes successfully" do
        commands.check_branch("my-branch", "my-branch", "production")
      end
    end
    
    context "if the branch is invalid" do
      it "raises an error" do
        expect{
          commands.check_branch("my-branch", "my-valid-branch", "production")
        }.to raise_error("Cannot deploy branch my-branch to production")
      end
    end
  end
  
  describe "#check_staged" do
    context "if the branch is staged" do
      it "executes successfully" do
        expect(commands).to receive(:git_staged?).with("my-remote", "my-branch").and_return(true)
        commands.check_staged("my-remote", "my-branch", "staging")
      end
    end
    
    context "if the branch isn't yet staged" do
      it "raises an error" do
        expect{
          commands.stub(:git_staged?).with("my-remote", "my-branch").and_return(false)
          commands.check_staged("my-remote", "my-branch", "staging")
        }.to raise_error("Changes not yet staged on staging")
      end
    end
  end
  
  describe "#check_config" do
    context "if all the required variables have values" do
      let(:attrs) { {'required' => ['my-var'], 'variables' => {'my-var' => 'some-value'}} }

      it "executes successfully" do
        commands.check_config(Heroploy::Config::SharedEnv.new(attrs))
      end
    end
    
    context "if a required variable is missing a value" do
      let(:attrs) { {'required' => ['my-var'], 'variables' => {}} }
      
      it "raises an error" do
        expect{
          commands.check_config(Heroploy::Config::SharedEnv.new(attrs))
        }.to raise_error("Missing config value for 'my-var'")
      end
    end
  end
end
