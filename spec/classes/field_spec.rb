require 'spec_helper'

describe X12::Field do
  let(:field_sep) { "*" }
  let(:segment_sep) { "~" }

  describe "A definition with a constant type" do
    # Field TransactionSetIdentifierCode|"997"|false|3-3|T143 <>
    subject { X12::Field.new("test", "\"997\"", false, 3, 3, nil) }

    it "should render properly" do
      subject.render.should == "997"
    end

    it "should return a regular expression" do
      subject.simple_regexp(field_sep, segment_sep).should == "997"
    end
  end

  describe "A string with no validation" do
    # Field TransactionSetControlNumber|string|false|4-9| <>
    subject { X12::Field.new("test", "string", false, 4, 9, nil) }

    it "should render properly" do
      subject.content = "blah"

      subject.render.should == "blah"
      subject.has_content?.should be_true
    end

    it "should render properly when there is no content" do
      subject.render.should == ""
      subject.has_content?.should be_false
    end

    it "should return a regular expression" do
      subject.simple_regexp(field_sep, segment_sep).should == "[^\\*~]*"
    end
  end

  describe "A string with a validation" do
    # Field TransactionSetIdentifierCode|string|true|3-3|T143 <>
    # Hmm, it doesn't actually touch that validation!
    subject { X12::Field.new("test", "blah", true, 3, 3, "T143") }

    it "should render properly" do
      subject.content = "997"

      subject.render.should == "997"
      subject.has_content?.should be_true
    end

    it "should render properly when there is no content" do
      subject.render.should == ""
      subject.has_content?.should be_false
    end
  end

  describe "a long" do
    # Field DataElementReferenceNumber|long|false|1-4| <>
  end

  describe "a composite" do
    # Field PositionInSegment|C030|true|1-999999| <>
  end

end
