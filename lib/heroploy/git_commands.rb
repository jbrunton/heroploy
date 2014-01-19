require 'heroploy/shell'

module GitCommands
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
  
  def git_tag(tag, message)
    Shell.exec("git tag -a #{tag} -m \"#{message}\"")
  end
  
  def git_push_tag(tag)
    Shell.exec("git push origin #{tag}")
  end
end
