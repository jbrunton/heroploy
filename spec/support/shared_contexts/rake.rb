# this file courtesy of http://robots.thoughtbot.com/test-rake-tasks-like-a-boss

require "rake"

shared_context "rake" do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/heroploy/tasks" }
#   let(:task_path) { "lib/tasks/#{task_name.split(":").first}" }
  subject         { rake[task_name] }
  
  include ShellSupport
  
  before do
    stub_shell
    
    Rake.application = rake
    puts "*** Heroploy.root.to_s: #{Heroploy.root.to_s}"
    
    heroploy_file = <<-EOF
      environments:
        production:
          heroku: my-production-app
    EOF
    deploy_config = DeployConfig.new(YAML.load(heroploy_file))
    DeployConfig.stub(:load).and_return(deploy_config)
    
    # Heroploy::RakeTask.new(deploy_config)
    
    Rake.application.define_task(Heroploy::RakeTask, deploy_config)
    
    puts "*** subject.prerequisites: #{subject.prerequisites}"
    puts "*** subject: #{subject}"
  end
end
