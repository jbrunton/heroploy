shared_context "generator" do
  include GeneratorSpec::TestCase
  destination TMP_ROOT

  before(:all) do
    prepare_destination
    
    APP_CONFIG_PATH = TMP_ROOT.join('config')
    FileUtils.mkpath APP_CONFIG_PATH

    run_generator
  end
  
  after(:all) do
    FileUtils.rm_rf TMP_ROOT
  end
end
