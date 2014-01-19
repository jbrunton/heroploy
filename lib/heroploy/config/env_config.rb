require 'heroploy/config/checks_config'

class EnvConfig
  attr_reader :name
  attr_reader :remote
  attr_reader :heroku
  attr_reader :tag
  attr_reader :checks
  
  def initialize(name, attrs)
    @name = name
    @remote = attrs['remote'] || name
    @heroku = attrs['heroku']
    @tag = attrs['tag']
    @checks = ChecksConfig.new(attrs['checks'])
  end
end
