module Heroploy
  module Config  
    class SharedEnv
      attr_accessor :required
      attr_accessor :variables
      
      def initialize(attrs = {})
        @required = attrs['required'] || []
        @variables = attrs['variables'] || {}
      end
    end
  end
end
