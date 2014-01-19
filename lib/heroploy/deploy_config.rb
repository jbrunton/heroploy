class ChecksConfig
  attr_reader :pushed
  attr_reader :branch
  attr_reader :staged
  
  def initialize(attrs)
    attrs ||= {}
    @pushed = attrs['pushed']
    @branch = attrs['branch']
    @staged = attrs['staged']
  end
end

class AppConfig
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

class DeployConfig
  attr_reader :apps
  
  def initialize(file_name)
    @apps = YAML::load(File.open(file_name))['apps']
    @apps.each do |app_name, attrs|
      @apps[app_name] = AppConfig.new(app_name, attrs)
    end
  end
end
