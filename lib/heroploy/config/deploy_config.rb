require 'heroploy/config/env_config'

class DeployConfig
  attr_reader :environments
  
  def initialize(attrs)
    @environments = attrs['environments']
    @environments.each do |name, attrs|
      @environments[name] = EnvConfig.new(name, attrs)
    end
  end
  
  def self.load
    DeployConfig.new(YAML::load(File.open('.heroploy.yml')))
  end
end
