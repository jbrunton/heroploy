describe "check:remote" do
  include_context "rake"
  
  let(:deploy_config) do
    build(:deploy_config)
  end

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
