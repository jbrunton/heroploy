require 'spec_helper'

describe HerokuCommands do
  let(:commands) { Object.new.extend(GitCommands) }
  
  context "#git_fetch" do
    it "executes a git fetch" do
      expect_command("git fetch")
      commands.git_fetch
    end
  end
  
  context "#current_branch" do
    let(:expected_output) { "master\n" }

    it "evaluates git rev-parse to figure out the current branch" do
      expect_eval("git rev-parse --abbrev-ref HEAD").and_return(expected_output)
      commands.current_branch
    end
    
    it "trims the output to just the branch name" do
      expect_eval.and_return(expected_output)
      expect(commands.current_branch).to eq("master")
    end
  end
end
