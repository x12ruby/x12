require 'spec_helper'

describe X12::Loop do
  let(:f_constant) { X12::Field.new("test1", "\"997\"", false, 3, 3, nil) }
  let(:field_1) { X12::Field.new("test2", "string", false, 3, 3, nil) }
  let(:field_2) { X12::Field.new("test3", "string", false, 3, 3, nil) }
  let(:segment) { X12::Segment.new("AA", [field_1, field_2], 1..999) }


  describe "#parse" do
    context "on a simple segment" do
      subject { X12::Loop.new("TEST", [segment], 1..2) }

      it "parses a correct string" do
        result = subject.parse("AA*foo*bar~")

        # should not return anything because the string is finished
        result.should == ""

        segments = subject.nodes[0]
        segments.size.should == 1
      end

      it "parses a string when there are two loops" do
        result = subject.parse("AA*foo*bar~AA*baz*bing~")

        result.should == ""

        subject.nodes[0].size.should == 2

      end

      # Not sure this is correct behaviour, as the definition above said 2 loops
      it "parses a string when there are three loops" do
        result = subject.parse("AA*foo*bar~AA*baz*bing~AA*chunky*bacon~")

        result.should == ""

        subject.nodes[0].size.should == 3

      end

      it "returns the rest of a string when there is more" do
        result = subject.parse("AA*foo*bar~BB*more*here*bub~")

        result.should == "BB*more*here*bub~"
      end
    end
  end

  describe "#render" do
  end


end
