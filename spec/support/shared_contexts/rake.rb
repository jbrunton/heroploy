# references:
#   http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
#   http://www.e-tobi.net/blog/2008/10/04/

require "rake"

shared_context "rake" do
  let(:task_name) {
    if defined?(environment)
      env_name = environment.name
    elsif defined?(environments)
      env_name = environments[0].name
    else
      env_name = deployment_config.environments[0].name
    end

    "#{env_name}:#{self.class.top_level_description}"
  }

  let(:task) { Rake::Task[task_name] }
  
  subject { task }
    
  before(:each) do
    Rake::Task.clear

    if defined?(deployment_config)
      @deployment_config = deployment_config
    else
      if defined?(environment)
        @environments = [environment]
      elsif defined?(environments)
        @environments = environments
      end
      
      @deployment_config = if @environments.nil?
        build(:deployment_config)
      else
        build(:deployment_config, environments: @environments)
      end
    end
    
    Heroploy::Tasks::DeployTaskLib.new(@deployment_config) 

    Rake::Task.tasks.each do |task|
      if task.name != task_name
        task.stub(:execute)
      end
    end

    stub_shell
  end  
end
