require 'spec_helper'

describe GitCommands do
  let(:commands) { Object.new.extend(GitCommands) }
  
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
      expect_command("git push my-repo my-branch:master")
      commands.git_push_to_master("my-repo", "my-branch")
    end
    
    it "appends the --force option if the 'force' ENV variable is set" do
      expect(ENV).to receive(:[]).and_return('true')
      expect_command("git push --force my-repo my-branch:master")
      commands.git_push_to_master("my-repo", "my-branch")
    end
  end
  
  context "#git_remote_exists?" do
    it "evaluates git remote to enumerate the available remotes" do
      expect_eval("git remote").and_return("")
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
end
