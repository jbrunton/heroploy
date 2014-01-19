require 'heroploy/config/env_config'

class DeployConfig
  attr_reader :environments
  
  def initialize(file_name)
    @environments = YAML::load(File.open(file_name))['environments']
    @environments.each do |name, attrs|
      @environments[name] = EnvConfig.new(name, attrs)
    end
  end
end
