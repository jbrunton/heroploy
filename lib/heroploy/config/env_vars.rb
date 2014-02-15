module Heroploy
  module Config  
    class EnvVars
      attr_accessor :required
      attr_accessor :common
      
      def initialize(attrs = {})
        @required = attrs['required']
        @common = attrs['common']
      end
    end
  end
end
