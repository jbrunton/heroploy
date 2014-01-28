describe "check:all" do
  let(:environment) { build(:env_config, :production) }

  context "in all cases" do
    include_context "rake"
    its(:prerequisites) { should include('remote') }
  end

  context "if checks.pushed is set" do
    before { environment.checks.pushed = true }
    include_context "rake"
    
    its(:prerequisites) { should include('pushed') }
  end
  
  context "if checks.pushed is not set" do
    before { environment.checks.pushed = false }
    include_context "rake"
    
    its(:prerequisites) { should_not include('pushed') }
  end
  
  context "if checks.staged is set" do  
    before { environment.checks.staged = true }
    include_context "rake"
    
    its(:prerequisites) { should include('staged') }
  end
  
  context "if checks.staged is not set" do
    before { environment.checks.staged = false }
    include_context "rake"
    
    its(:prerequisites) { should_not include('staged') }
  end
  
  context "if checks.branch is set" do
    before { environment.checks.branch = 'master' }
    include_context "rake"
    
    its(:prerequisites) { should include('branch') }
  end
  
  context "if checks.staged is not set" do
    before { environment.checks.branch = nil }
    include_context "rake"
    
    its(:prerequisites) { should_not include('branch') }
  end
end
