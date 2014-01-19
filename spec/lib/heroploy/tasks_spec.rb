describe "heroploy:production:check:remote" do

  before(:each) do
    Rake::Task.clear
    heroploy_file = <<-EOF
      environments:
        production:
          heroku: my-production-app
    EOF
    deploy_config = DeployConfig.new(YAML.load(heroploy_file))
    @tasklib = Heroploy::RakeTask.new(deploy_config)
    
    Rake::Task.tasks.each do |task|
      if task.name != 'production:check:remote'
        task.stub(:execute)
      end
    end
  end
  
  let(:task) { Rake::Task['production:check:remote'] }
  let(:tasklib) { @tasklib }
  
  it "invokes :git_remote_exists?" do
    expect(tasklib).to receive(:git_remote_exists?).with('production').and_return(true)
    task.invoke
  end
  
  context "if the remote repository exists" do    
    it "executes successfully" do
      expect(tasklib).to receive(:git_remote_exists?).with('production').and_return(true)
      task.invoke
    end
  end
  
  context "if the remote repository doesn't exist" do
    it "throws an error" do
      expect(tasklib).to receive(:git_remote_exists?).with('production').and_return(false)
      expect{task.invoke}.to raise_error("Could not find remote 'production'")
    end
  end
end

describe "heroploy:production:deploy" do
  before(:each) do
    Rake::Task.clear
    heroploy_file = <<-EOF
      environments:
        production:
          heroku: my-production-app
    EOF
    deploy_config = DeployConfig.new(YAML.load(heroploy_file))
    Heroploy::RakeTask.new(deploy_config)
    
    Rake::Task.tasks.each do |task|
      if task.name != 'production:deploy'
        task.stub(:execute)
      end
    end
  end
  
  let(:task) { Rake::Task['production:deploy'] }
  
  it "should have the following prerequisites" do
    expect(task.prerequisites).to eq ["check:all", "push", "migrate", "tag"]
  end
  
  it "should execute" do
    task.invoke
  end
end
