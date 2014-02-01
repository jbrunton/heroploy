require 'heroploy/config/checks_config'

class EnvConfig
  attr_accessor :name
  attr_accessor :remote
  attr_accessor :app
  attr_accessor :tag
  attr_accessor :checks
  
  def self.parse(name, attrs)
    config = EnvConfig.new
    
    config.name = name
    config.remote = attrs['remote'] || name
    config.app = attrs['app']
    config.tag = attrs['tag']
    config.checks = ChecksConfig.parse(attrs['checks'])

    config
  end
end
