# references:
#   http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
#   http://www.e-tobi.net/blog/2008/10/04/

require "rake"

shared_context "rake" do
  let(:task_name) { "production:#{self.class.top_level_description}" }
  let(:task) { Rake::Task[task_name] }
  let(:tasklib) { @tasklib }
  let(:deploy_config) { build(:deploy_config) }
  let(:environment) { deploy_config.environments[0] }
  
  subject { task }
  
  before(:each) do
    Rake::Task.clear
    
    stub_shell
    
    @tasklib = Heroploy::TaskLib.new(deploy_config)
    
    Rake::Task.tasks.each do |task|
      if task.name != task_name
        task.stub(:execute)
      end
    end
  end  
end
