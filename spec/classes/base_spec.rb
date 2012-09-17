require 'spec_helper'

describe X12::Base do
  context "with no sub nodes" do
    subject { X12::Base.new("TEST", []) }

    describe "#find" do
      it "can't find anything underneath it" do
        subject.find("foo").should == X12::EMPTY
      end
    end
  end

end
