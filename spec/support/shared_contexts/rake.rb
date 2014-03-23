# references:
#   http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
#   http://www.e-tobi.net/blog/2008/10/04/

require "rake"

shared_context "rake" do
  subject { task }
  let(:task) { Rake::Task[task_name] }
  let(:task_name) { build_task_name }
    
  before(:each) do
    reset_rake_environment
    create_deployment_tasks 
    stub_rake_tasks
    stub_shell
  end
  
  def reset_rake_environment
    Rake::Task.clear
  end
  
  def create_deployment_tasks
    Heroploy::Tasks::DeployTaskLib.new(build_deployment_config)
  end
  
  def stub_rake_tasks
    Rake::Task.tasks.each do |task|
      if task.name != task_name
        task.stub(:execute)
      end
    end
  end
  
  def build_environments
    if defined?(environment)
      [environment]
    elsif defined?(environments)
      environments
    end
  end
  
  def build_deployment_config
    if defined?(deployment_config)
      deployment_config
    else
      environments = build_environments
      
      if environments.nil?
        build(:deployment_config)
      else
        build(:deployment_config, environments: environments)
      end
    end
  end
  
  def build_task_name
    if defined?(environment)
      env_name = environment.name
    elsif defined?(environments)
      env_name = environments[0].name
    else
      env_name = deployment_config.environments[0].name
    end

    "#{env_name}:#{self.class.top_level_description}"
  end
end
