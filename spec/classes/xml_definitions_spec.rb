require 'spec_helper'
describe X12::XMLDefinitions do
  describe "#initialize" do
    let(:something) { double(name: :something) }

    context "where the root is a definition" do
      it "parses the loop element" do
        described_class.any_instance.should_receive(:parse_loop).and_return(something)
        described_class.new('<Definition><Loop name="test" comment="test"></Loop></Definition>')
      end
    end

    context "where the root is not a definition" do

      it "parses the loop element" do
        described_class.any_instance.should_receive(:parse_loop).and_return(something)
        described_class.new('<Loop name="test" comment="test"></Loop>')
      end
    end

    context "a loop" do

      subject { described_class.new('<Definition><Loop name="test" comment="test"></Loop></Definition>') }

      context "containing another loop" do
        subject { described_class.new('<Loop name="outer"><Loop name="inner" comment="test"></Loop></Loop>') }

        it "parses the outer loop" do
          expect(subject[X12::Loop].keys).to eq [ "outer" ]
        end

        it "parses the inner loop" do
          inner = subject[X12::Loop]["outer"].nodes
          expect(inner.first).to be_an_instance_of X12::Loop
        end
      end

      context "containing a segment" do
        subject { described_class.new('<Loop name="outer"><Segment name="inner" comment="test" /></Loop>') }

        it "parses the outer loop" do
          expect(subject[X12::Loop].keys).to eq [ "outer" ]
        end

        it "parses the inner loop" do
          inner = subject[X12::Loop]["outer"].nodes
          expect(inner.first.class).to eq X12::Segment
        end
      end

    end

    context "a table" do
      subject { described_class.new('<Table name="test"><Entry name="A" value="something"/><Entry name="B" value="another" /></Table>') }

      it "parses the table" do
        expect(subject[X12::Table].keys).to eq [ "test" ]
      end

      it "parses the entries" do
        table = subject[X12::Table]["test"]

        expect(table).to eq({"A" => "something", "B" => "another"})
      end
    end

    context "a segment" do
      subject { described_class.new('<Segment name="ST" required="y" max="1"><Field name="field1" const="270" comment="field"/></Segment>') }

      it "parses the segment" do
        expect(subject[X12::Segment].keys).to eq [ "ST" ]
      end

      it "parses the fields" do
        segment = subject[X12::Segment]["ST"]

        expect(segment.nodes.map(&:class)).to eq [ X12::Field ]
      end
    end

    context "a composite" do
      subject { described_class.new('<Composite name="C043" comment="foo"><Field name="field1" min="1" max="30" comment="fieldcomment"/></Composite>') }

      it "parses the composite" do
        expect(subject[X12::Composite].keys).to eq [ "C043" ]
      end

      it "parses the fields" do

        composite = subject[X12::Composite]["C043"]

        expect(composite.nodes.map(&:class)).to eq [ X12::Field ]
      end
    end

  end
end
