require 'spec_helper'

describe Heroploy::Commands::Git do
  before(:each) do
    stub_shell
  end
  
  let(:commands) { Object.new.extend(Heroploy::Commands::Git) }
  
  context "#git_fetch" do
    it "executes a git fetch" do
      expect_command("git fetch")
      commands.git_fetch
    end
  end
  
  context "#current_branch" do
    let(:expected_rev_parse_output) { "master\n" }

    it "evaluates git rev-parse to figure out the current branch" do
      expect_eval("git rev-parse --abbrev-ref HEAD").and_return(expected_rev_parse_output)
      commands.current_branch
    end
    
    it "trims the output to just the branch name" do
      expect_eval.and_return(expected_rev_parse_output)
      expect(commands.current_branch).to eq("master")
    end
  end
  
  context "#git_push_to_master" do
    it "pushes the local branch to the remote master" do
      expect_command("git push my-remote my-branch:master")
      commands.git_push_to_master("my-remote", "my-branch")
    end
    
    it "appends the --force option if the 'force' ENV variable is set" do
      expect(ENV).to receive(:[]).and_return('true')
      expect_command("git push --force my-remote my-branch:master")
      commands.git_push_to_master("my-remote", "my-branch")
    end
  end
  
  context "#git_remote_exists?" do
    it "evaluates git remote to enumerate the available remotes" do
      expect_eval("git remote")
      commands.git_remote_exists?("my-remote")
    end
    
    it "returns true if the given remote exists" do
      expect_eval("git remote").and_return("origin\nstaging\nproduction")
      expect(commands.git_remote_exists?("staging")).to eq(true)
    end

    it "returns false if the given remote doesn't exist" do
      expect_eval("git remote").and_return("origin\nproduction")
      expect(commands.git_remote_exists?("staging")).to eq(false)
    end
  end
  
  context "#git_remote_has_branch?" do
    it "evaluates git branch -r to determine the remote branches" do
      expect_eval("git branch -r")
      commands.git_remote_has_branch?("my-remote", "my-branch")
    end
    
    it "returns true if the remote has a branch with the given name" do
      expect_eval("git branch -r").and_return("  my-remote/my-branch\n  my-remote/other-branch\n")
      expect(commands.git_remote_has_branch?("my-remote", "my-branch")).to be(true)
    end

    it "returns false if the remote has no branch with the given name" do
      expect_eval("git branch -r").and_return("  my-remote/other-branch\n")
      expect(commands.git_remote_has_branch?("my-remote", "my-branch")).to be(false)
    end
  end
  
  context "#git_remote_behind?" do
    it "inspects the git log to see if the remote is ahead" do
      expect_eval("git log my-remote/my-remote-branch..my-local-branch")
      commands.git_remote_behind?("my-remote", "my-remote-branch", "my-local-branch")
    end
    
    it "uses the remote branch name as the local branch name if none is supplied" do
      expect_eval("git log my-remote/my-branch..my-branch")
      commands.git_remote_behind?("my-remote", "my-branch")
    end
    
    it "returns true if git log returns commits" do
      expect_eval("git log my-remote/my-remote-branch..my-local-branch").and_return("commit a1b2c3d")
      expect(commands.git_remote_behind?("my-remote", "my-remote-branch", "my-local-branch")).to eq(true)
    end

    it "returns false if git log returns no commits" do
      expect_eval("git log my-remote/my-remote-branch..my-local-branch").and_return("")
      expect(commands.git_remote_behind?("my-remote", "my-remote-branch", "my-local-branch")).to eq(false)
    end  
  end
  
  context "#git_staged?" do
    it "returns true if the remote master is up to date" do
      expect_eval("git log my-remote/master..my-local-branch").and_return("")
      expect(commands.git_staged?("my-remote", "my-local-branch")).to eq(true)
    end

    it "returns false if the remote master is behind" do
      expect_eval("git log my-remote/master..my-local-branch").and_return("commit a1b2c3d")
      expect(commands.git_staged?("my-remote", "my-local-branch")).to eq(false)
    end  
  end
  
  context "#git_tag" do
    it "creates a tag with the given name and message" do
      expect_command("git tag -a my-tag -m \"my message\"")
      commands.git_tag("my-tag", "my message")
    end
  end
end
