# this file courtesy of http://robots.thoughtbot.com/test-rake-tasks-like-a-boss

require "rake"

shared_context "rake" do
  let(:task_name) { self.class.top_level_description }
  let(:task) { Rake::Task[task_name] }
  let(:tasklib) { @tasklib }

  subject { task }
  
  before(:each) do
    Rake::Task.clear
    heroploy_file = <<-EOF
      environments:
        production:
          heroku: my-production-app
    EOF
    
    deploy_config = DeployConfig.new(YAML.load(heroploy_file))
    @tasklib = Heroploy::TaskLib.new(deploy_config)
    
    Rake::Task.tasks.each do |task|
      if task.name != task_name
        task.stub(:execute)
      end
    end
  end  
end
