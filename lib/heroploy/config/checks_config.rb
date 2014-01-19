class ChecksConfig
  attr_accessor :pushed
  attr_accessor :branch
  attr_accessor :staged
  
  def self.parse(attrs)
    config = ChecksConfig.new
    
    attrs ||= {}
    config.pushed = attrs['pushed']
    config.branch = attrs['branch']
    config.staged = attrs['staged'] == true ? 'staging' : attrs['staged']
    
    config
  end
end
