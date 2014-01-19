require 'heroploy/config/env_config'

class DeployConfig
  attr_accessor :environments
  
  def self.parse(attrs)
    config = DeployConfig.new
    
    config.environments = [] 
    attrs['environments'].each do |name, attrs|
      config.environments << EnvConfig.parse(name, attrs)
    end
    
    config
  end
  
  def self.load
    DeployConfig.parse(YAML::load(File.open('.heroploy.yml')))
  end
end
