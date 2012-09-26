require 'spec_helper'
describe X12::XMLDefinitions do
  describe "#initialize" do
    context "a simple document with an embedded loop" do

      it "parses the next tag" do
        obj = X12::XMLDefinitions.new('<Definition><Loop name="test" comment="test"></Loop></Definition>')

        obj.keys.size.should == 1
      end

    end
  end

  describe "#loop" do
    let(:loop) { REXML::Document.new('<loop name="test" comment="test"></loop>') }

    subject { X12::XMLDefinitions.new("<Definition />") }

    it "parses the parameters out of a loop" do
      #parse = subject.loop(loop)

      #parse.class.should == Loop

    end

  end

end
