require 'spec_helper'

describe "db:reset" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes heroku_db_reset" do
    expect_any_instance_of(Heroploy::Tasks::EnvTaskLib).to receive(:heroku_db_reset)
      .with("my-production-app")
    
    task.invoke
  end
end

describe "db:migrate" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes heroku_db_migrate" do
    expect_any_instance_of(Heroploy::Tasks::EnvTaskLib).to receive(:heroku_db_migrate)
      .with("my-production-app")
    
    task.invoke
  end
end

describe "db:seed" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  it "invokes heroku_db_seed" do
    expect_any_instance_of(Heroploy::Tasks::EnvTaskLib).to receive(:heroku_db_seed)
      .with("my-production-app")
    
    task.invoke
  end
end

describe "db:recreate" do
  let(:environment) { build(:environment, :production) }
  include_context "rake"
  
  its(:prerequisites) { should eq ['reset', 'migrate', 'seed'] }
end
