require 'spec_helper'

describe Shell do
  context "#eval" do
    it "evaluates the given command using backticks" do
      expect(Shell).to receive(:`).with('date')
      Shell.eval('date')
    end

    it "returns the standard output from the shell command" do
      expected_output = "Sun 19 Jan 2014 01:20:23 GMT\n"
      expect(Shell).to receive(:`).and_return(expected_output)
      expect(Shell.eval('date')).to eq(expected_output)
    end
  end
end
