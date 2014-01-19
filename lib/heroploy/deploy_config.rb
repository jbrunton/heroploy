class ChecksConfig
  attr_reader :origin
  attr_reader :staged
  
  def initialize(attrs)
    attrs ||= {}
    @origin = attrs['origin']
    @staged = attrs['staged']
  end
end

class AppConfig
  attr_reader :name
  attr_reader :remote
  attr_reader :heroku
  attr_reader :branches
  attr_reader :merge
  attr_reader :tag
  attr_reader :push
  attr_reader :checks
  
  def initialize(name, attrs)
    @name = name
    @remote = attrs['remote'] || name
    @heroku = attrs['heroku']
    @merge = attrs['merge']
    @tag = attrs['tag']
    @push = attrs['push']
    @branches = attrs['branches'] || '*'
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
