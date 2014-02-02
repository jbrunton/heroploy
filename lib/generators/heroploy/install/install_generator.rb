module Heroploy
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_config
        copy_file "config/heroploy.yml"
      end  
    end
  end
end
