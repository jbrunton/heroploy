module GitCommands
  def git_fetch
    FileUtils.sh "git fetch"
  end
  
  def current_branch
    branch = Shell.eval "git rev-parse --abbrev-ref HEAD"
    branch.strip
  end
  
  def git_push(repo_name, local_branch)
    if ENV['force'] == 'true'
      opts = "--force "
    end
    
    sh "git push #{opts}#{repo_name} #{local_branch}:master"
  end
end
