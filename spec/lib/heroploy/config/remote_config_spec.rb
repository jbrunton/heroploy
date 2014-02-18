require 'spec_helper'

describe Heroploy::Config::RemoteConfig do
  describe "#initialize" do
    context "it initializes the accessors" do
      let(:attrs) { {'repository' => 'my-repo.git'} }
      subject(:remote_config) { Heroploy::Config::RemoteConfig.new('my-config', attrs) }

      its(:name) { should eq('my-config') }
      its(:repository) { should eq('my-repo.git') }      
    end    
    
    context "if a single file is defined" do
      let(:attrs) { {'file' => 'config.yml'} }  
      subject(:remote_config) { Heroploy::Config::RemoteConfig.new('my-config', attrs) }

      it "defines the :files accessor correctly" do
        expect(remote_config.files).to eq(['config.yml'])
      end
    end
    
    context "if multiple files are defined" do
      let(:attrs) { {'files' => ['config1.yml', 'config2.yml']} }  
      subject(:remote_config) { Heroploy::Config::RemoteConfig.new('my-config', attrs) }

      it "defines the :files accessor correctly" do
        expect(remote_config.files).to include('config1.yml')
        expect(remote_config.files).to include('config2.yml')
      end
    end   
  end
end
