Given(/^a (development|staging|production) environment$/) do |env_type|
  @environments ||= []
  @environments << build(:environment, env_type.to_sym)
  
  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:git_remote_exists?).
    with(env_type).
    and_return(true)

  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:git_remote_has_branch?).
    and_return(true)
end

When(/^I run "(.*?)"$/) do |task_name|
  Rake::Task.clear

  @deployment_config = build(:deployment_config, environments: @environments)
  Heroploy::Tasks::DeployTaskLib.new(@deployment_config)

  @travis_repo = build(:travis_repo)
  Travis::Repository.stub(:find).and_return(@travis_repo)

  @travis_build ||= build(:travis_build, :passed)
  allow(@travis_repo).to receive(:branch).and_return(@travis_build)

  Rake::Task.tasks.each do |task|
    allow(task).to receive(:execute).and_call_original
  end

  begin
    Rake::Task[task_name].invoke
  rescue => error
    @error = error
  end
end

Then(/^heroploy should execute "(.*?)"$/) do |command|
  expect(Heroploy::Shell).to have_received(:exec).with(command)
end

Then(/^heroploy should invoke "(.*?)"$/) do |task_name|
  expect(Rake::Task[task_name]).to have_received(:execute)
end

When(/^I have "(.*?)" checked out$/) do |branch_name|
  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:current_branch).and_return(branch_name)
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
  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:git_remote_behind?).and_return(true)
end

When(/^my changes aren't yet staged$/) do
  allow_any_instance_of(Heroploy::Tasks::CheckTaskLib).to receive(:git_staged?).and_return(false)
end
