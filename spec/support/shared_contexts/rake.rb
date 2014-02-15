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
    
    unless defined?(env_vars)
      puts "*** variables undefined"
      env_vars = build(:env_vars)
    else
      puts "*** env_vars defined: #{env_vars.to_s}"
      puts "*** nil: #{nil.to_s}"
    end
    
    unless defined?(deploy_config)
      puts "*** generating deploy_config"
      if defined?(environment)
        deployment_config = build(:deployment_config, environments: [environment], variables: env_vars)
      elsif defined?(environments)
        deployment_config = build(:deployment_config, environments: environments, variables: env_vars)
      else
        deployment_config = build(:deployment_config, variables: env_vars)
      end
    end

    Heroploy::Tasks::DeployTaskLib.new(deployment_config) 

    Rake::Task.tasks.each do |task|
      if task.name != task_name
        task.stub(:execute)
      end
    end

    stub_shell
  end  
end
