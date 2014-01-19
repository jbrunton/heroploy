class ChecksConfig
  attr_reader :pushed
  attr_reader :branch
  attr_reader :staged
  
  def initialize(attrs)
    attrs ||= {}
    @pushed = attrs['pushed']
    @branch = attrs['branch']
    @staged = attrs['staged'] || 'staging'
  end
end
