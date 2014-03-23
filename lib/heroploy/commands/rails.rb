require 'heroploy/commands/shell'

module Heroploy
  module Commands
    module Rails
      def rails_server(shared_vars, env_vars)
        merged_vars = shared_vars.merge(env_vars)
        vars_string = merged_vars.collect.map{|key,value| "#{key}=#{value}"}.join(" ")
        Shell.exec "bundle exec #{vars_string} rails s"
      end
    end
  end
end
