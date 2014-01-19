describe "production:check:remote" do
  include_context "rake"

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

describe "production:deploy" do
  include_context "rake"

  it "should have the following prerequisites" do
    expect(task.prerequisites).to eq ["check:all", "push", "migrate", "tag"]
  end
  
  it "should execute" do
    task.invoke
  end
end
