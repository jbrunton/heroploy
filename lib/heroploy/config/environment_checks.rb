module Heroploy
  module Config
    class EnvironmentChecks
      attr_accessor :pushed
      attr_accessor :branch
      attr_accessor :staged
      attr_accessor :travis
      
      def initialize(attrs = {})
        attrs ||= {}
        @pushed = attrs['pushed']
        @branch = attrs['branch']
        @staged = attrs['staged'] == true ? 'staging' : attrs['staged']
        @travis = attrs['travis']
      end  
    end
  end
end
