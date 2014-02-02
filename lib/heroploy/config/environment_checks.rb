module Heroploy
  module Config
    class EnvironmentChecks
      attr_accessor :pushed
      attr_accessor :branch
      attr_accessor :staged
      
      def initialize(attrs = {})
        attrs ||= {}
        @pushed = attrs['pushed']
        @branch = attrs['branch']
        @staged = attrs['staged'] == true ? 'staging' : attrs['staged']
      end  
    end
  end
end
