require 'heroploy/commands/shell'

module Heroploy
  module Commands
    module Rails
      def rails_server(shared_vars, env_vars)
        merged_vars = shared_vars.merge(env_vars)
        vars_string = merged_vars.collect.map{|key,value| "#{key}=#{value}"}.join(" ")
        cmd = "bundle exec rails s"
        cmd = "#{vars_string} #{cmd}" unless vars_string.empty?
        Shell.exec cmd
      end
    end
  end
end
