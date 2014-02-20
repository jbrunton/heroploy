require 'travis'

module Heroploy
  module Commands
    module Checks
      def check_remote(remote)
        unless git_remote_exists?(remote)
          raise "Could not find remote '#{remote}'"
        end
      end
    
      def check_pushed(branch_name)
        unless git_remote_has_branch?('origin', branch_name)
          raise "Branch #{branch_name} doesn't exist in origin"
        end

        if git_remote_behind?('origin', branch_name) then
          raise "Branch #{branch_name} is behind origin/#{branch_name}"
        end
      end
    
      def check_branch(branch_name, valid_branch, env_name)
        unless branch_name == valid_branch
          raise "Cannot deploy branch #{branch_name} to #{env_name}"
        end
      end
    
      def check_staged(remote, branch_name, env_name)
        unless git_staged?(remote, branch_name)
          raise "Changes not yet staged on #{env_name}"
        end
      end
      
      def check_config(shared_env, env_config)
        merged_keys = shared_env.variables.keys.concat(env_config.variables.keys)
        shared_env.required.each do |key|
          unless merged_keys.include?(key)
            raise "Missing config value for '#{key}'"
          end
        end
      end
      
      def check_travis(branch_name, travis_repo_name)
        travis_repo = Travis::Repository.find(travis_repo_name)
        unless travis_repo.branch(branch_name).green?
          raise "Failing Travis build for branch #{branch_name}"
        end
      end
    end
  end
end
