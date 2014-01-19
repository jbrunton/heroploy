module GitCommands
  def git_fetch
    FileUtils.sh "git fetch"
  end
  
  def current_branch
    branch = Shell.eval "git rev-parse --abbrev-ref HEAD"
    branch.strip
  end
  
  def git_push_to_master(repo_name, local_branch)
    if ENV['force'] == 'true' then opts = "--force " end
    FileUtils.sh "git push #{opts}#{repo_name} #{local_branch}:master"
  end
  
  def git_remote_exists?(name)
    remotes = Shell.eval("git remote").strip.split(/\s+/)
    remotes.include?(name)
  end
end
