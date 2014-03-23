def define_environment(env_type)
  @environments ||= []
  environment = build(:environment, env_type.to_sym)
  @environments << environment
  environment
end

Given(/^a (local|development|staging|production) environment$/) do |env_type|
  define_environment(env_type)
end

Given(/^a (local|development|staging|production) environment with variables:$/) do |env_type, variables|
  environment = define_environment(env_type)
  environment.variables = YAML::load(variables) unless variables.nil?
end

Given(/^a shared environment with variables:$/) do |variables|
  @shared_env = build(:shared_env, variables: YAML::load(variables))
end

def init_tasks
  @shared_env ||= build(:shared_env)
  deployment_config = build(:deployment_config, environments: @environments, shared_env: @shared_env)
  Heroploy::Tasks::DeployTaskLib.new(deployment_config)
end

def stub_tasks
  Rake::Task.tasks.each do |task|
    allow(task).to receive(:execute).and_call_original
  end
end

def stub_travis
  @travis_repo = build(:travis_repo)
  Travis::Repository.stub(:find).and_return(@travis_repo)

  @travis_build ||= build(:travis_build, :passed)
  allow(@travis_repo).to receive(:branch).and_return(@travis_build)  
end

When(/^I run "(.*?)"$/) do |task_name|
  init_tasks
  stub_travis
  stub_tasks
  
  begin
    Rake::Task[task_name].invoke
  rescue => error
    @error = error
  end
end

Then(/^heroploy should execute "(.*?)"$/) do |command|
  expect(Heroploy::Shell).
    to have_received(:exec).
    with(command)
end

Then(/^heroploy should invoke "(.*?)"$/) do |task_name|
  expect(Rake::Task[task_name]).
    to have_received(:execute)
end

When(/^I have "(.*?)" checked out$/) do |branch_name|
  @branch_name = branch_name
  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).
    to receive(:current_branch).
    and_return(branch_name)
end

Given(/^the travis build is failing$/) do
  @travis_build = build(:travis_build, :failed)
end

Then(/^the task should fail with "(.*?)"$/) do |expected_error|
  unless @error.to_s == expected_error
    if @error.nil?
      raise "Expected failure with message '#{expected_error}' while executing task, but execution was successful"
    else
      puts "Expected failure with message '#{expected_error}' while executing task, but encountered:"
      raise @error
    end
  end
end

When(/^my branch is ahead of origin$/) do
  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).
    to receive(:git_remote_behind?).
    with('origin', @branch_name).
    and_return(true)
end

When(/^my branch is ahead of staging$/) do
  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).
    to receive(:git_remote_behind?).
    with('staging', 'master', @branch_name).
    and_return(true)
end
