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
      env_name = deploy_config.environments[0].name
    end

    "#{env_name}:#{self.class.top_level_description}"
  }

  let(:task) { Rake::Task[task_name] }
  
  subject { task }
  
  before(:each) do
    Rake::Task.clear
    
    unless defined?(deploy_config)
      if defined?(environment)
        deploy_config = build(:deploy_config, environments: [environment])
      elsif defined?(environments)
        deploy_config = build(:deploy_config, environments: environments)
      else
        deploy_config = build(:deploy_config)
      end
    end

    Heroploy::DeployTaskLib.new(deploy_config) 

    Rake::Task.tasks.each do |task|
      if task.name != task_name
        task.stub(:execute)
      end
    end

    stub_shell
  end  
end
