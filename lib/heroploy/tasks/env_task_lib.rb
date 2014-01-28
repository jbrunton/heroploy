require 'rake/tasklib'

require 'heroploy/commands/heroku'
require 'heroploy/commands/git'
require 'heroploy/commands/checks'

require 'heroploy/config/deploy_config'
require 'heroploy/tasks/check_task_lib'

module Heroploy
  class EnvTaskLib < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)
    
    include Commands::Git
    include Commands::Heroku
    include Commands::Checks
    
    def initialize(deploy_config, env_config)
      namespace env_config.name do
        namespace :check do
          CheckTaskLib.new(deploy_config, env_config)
        end

        desc "push the current branch to master on #{env_config.name}"
        task :push do
          git_push_to_master(env_config.remote, current_branch)
        end

        desc "run database migrations on #{env_config.name}"
        task :migrate do
          heroku_migrate(env_config.heroku)
        end

        desc "tag the deployment to #{env_config.name}"
        task :tag do
          if env_config.tag then
            tag = DateTime.now.strftime(env_config.tag)
            git_tag(tag, "Deployed #{current_branch} to #{env_config.name}")
            git_push_tag(tag)
          end
        end

        desc "deploy to #{env_config.name}"
        task :deploy => ['check:all', :push, :migrate, :tag]
      end
    end
  end
end
