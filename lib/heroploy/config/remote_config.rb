module Heroploy
  module Config  
    class RemoteConfig
      attr_accessor :name
      attr_accessor :repository
      attr_accessor :files
      
      def initialize(name, attrs = {})
        @name = name
        @repository = attrs['repository']
        @files = attrs['file'] ? [attrs['file']] : attrs['files']
      end
    end
  end
end
