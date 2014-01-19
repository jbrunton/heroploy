require 'heroploy/shell'

module Commands
  module Git
    def git_fetch
      Shell.exec "git fetch"
    end
  
    def current_branch
      branch = Shell.eval "git rev-parse --abbrev-ref HEAD"
      branch.strip
    end
  
    def git_push_to_master(remote, local_branch)
      if ENV['force'] == 'true' then opts = "--force " end
      Shell.exec "git push #{opts}#{remote} #{local_branch}:master"
    end
  
    def git_remote_exists?(name)
      remotes = Shell.eval("git remote").strip.split(/\s+/)
      remotes.include?(name)
    end
  
    def git_remote_has_branch?(remote, branch_name)
      branches = Shell.eval("git branch -r").strip.split(/\s+/)
      branches.include?("#{remote}/#{branch_name}")
    end
  
    def git_remote_behind?(remote, remote_branch_name, local_branch_name = nil)
      if local_branch_name.nil? then local_branch_name = remote_branch_name end
      !Shell.eval("git log #{remote}/#{remote_branch_name}..#{local_branch_name}").empty?
    end
  
    def git_staged?(remote, local_branch)
      !git_remote_behind?(remote, 'master', local_branch)
    end
  
    def git_tag(tag, message)
      Shell.exec("git tag -a #{tag} -m \"#{message}\"")
    end
  
    def git_push_tag(tag)
      Shell.exec("git push origin #{tag}")
    end
  end
end
