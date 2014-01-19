require 'heroploy/config/app_config'

class DeployConfig
  attr_reader :apps
  
  def initialize(file_name)
    @apps = YAML::load(File.open(file_name))['apps']
    @apps.each do |app_name, attrs|
      @apps[app_name] = AppConfig.new(app_name, attrs)
    end
  end
end
