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
      
      def check_config(config_vars)
        config_vars.required.each do |key|
          unless config_vars.common.keys.include?(key)
            raise "Missing config value for '#{key}'"
          end
        end
      end
    end
  end
end
