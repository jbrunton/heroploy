require 'spec_helper'
require File.expand_path('../../../../../lib/generators/heroploy/install/install_generator', __FILE__)

describe Heroploy::InstallGenerator do
  include_context "generator"

  it "copies the heroploy.yml template" do
    destination_root.should have_structure {
      directory 'config' do
        file 'heroploy.yml'
      end
    }
  end
end
