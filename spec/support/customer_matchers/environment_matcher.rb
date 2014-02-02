module CustomMatchers
  class EnvironmentMatcher
    def initialize(expected_name)
      @expected_name = expected_name
    end
  
    def matches_type?
      @actual.is_a?(Heroploy::Config::Environment)
    end
  
    def matches_name?
      @actual.name == @expected_name.to_s
    end
  
    def matches?(actual)
      @actual = actual
      matches_type? && matches_name?
    end
  
    def failure_message_for_should
      if !matches_type?
        "expected type to be Heroploy::Config::Environment"
      elsif !matches_name?
        "expected '#{@actual.name}' to be '#{@expected_name.to_s}'"
      end
    end
  end

  def an_environment_named(expected_name)  
    EnvironmentMatcher.new(expected_name)  
  end

  def be_an_environment_named(expected_name)
    EnvironmentMatcher.new(expected_name)
  end
end
