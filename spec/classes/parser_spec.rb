require 'spec_helper'

describe X12::Parser do
  describe "#initialize" do

    it "processes a file" do
      File.stub_chain(:open, :read).and_return(sample_xml)
      p = X12::Parser.new("blah.xml")
      definition = p.instance_variable_get("@x12_definition")


      definition.class.should == X12::XMLDefinitions
      definition.keys.count.should == 1
      definition.include?(X12::Loop).should be_true

      definition[X12::Loop].include?("outer").should be_true
    end

  end


  describe ".sanitized_file_name" do
    it "returns a regular file name" do
      X12::Parser.sanitized_file_name("blah.xml").should == "blah.xml"
    end

    it "returns a regular directory name" do
      X12::Parser.sanitized_file_name("/path/to/blah.xml").should == "/path/to/blah.xml"
    end

    it "returns a modified DOS file name" do
      X12::Parser.sanitized_file_name("COM1.xml").should == "./COM1_.xml"
    end

    it "returns a modified DOS directory name" do
      X12::Parser.sanitized_file_name("/path/to/COM1.xml").should == "/path/to/COM1_.xml"
    end

  end


end
