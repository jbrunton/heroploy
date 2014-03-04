Given(/^a production environment$/) do
  @deployment_config = build(:deployment_config, environments: [
    build(:environment, :production)
  ])
end

When(/^I run "(.*?)"$/) do |task_name|
  Rake::Task.clear
  Heroploy::Tasks::DeployTaskLib.new(@deployment_config)
  Rake::Task.tasks.each do |task|
    allow(task).to receive(:execute).and_call_original
  end
  Rake::Task[task_name].invoke
end

Then(/^heroploy should execute "(.*?)"$/) do |command|
  expect(Heroploy::Shell).to have_received(:exec).with(command)
end

Then(/^heroploy should invoke "(.*?)"$/) do |task_name|
  expect(Rake::Task[task_name]).to have_received(:execute)
end
