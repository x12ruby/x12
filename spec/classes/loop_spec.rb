require 'spec_helper'

describe X12::Loop do
  let(:f_constant) { X12::Field.new("test1", "\"997\"", false, 3, 3, nil) }
  let(:field_1) { X12::Field.new("test2", "string", false, 3, 3, nil) }
  let(:field_2) { X12::Field.new("test3", "string", false, 3, 3, nil) }
  let(:segment) { X12::Segment.new("AA", [field_1, field_2], 1..999) }
  let(:gs_segment) { X12::Segment.new("GS", [field_1], 1..999) }
  let(:aa_segment) { X12::Segment.new("AA", [field_1], 1..999) }
  let(:bb_segment) { X12::Segment.new("BB", [field_2], 1..999) }


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

    context "on a basic loop that involves repeats" do
      context "with no constraints" do
        subject { X12::Loop.new("LOOP", [gs_segment, aa_segment], 1..999) }

        context "and a complete document" do
          before { @result = subject.parse("GS*first~AA*one~GS*second~AA*two~") }

          it "parses a correct string" do
            # should not return anything because the string is finished
            @result.should == ""
          end

          it "has two loops" do
            subject.to_a.size.should == 2
            subject[0].to_s.should == "GS*first~AA*one~"
            subject[1].to_s.should == "GS*second~AA*two~"
          end
        end

        context "and a document that has a second loop that starts similar to the first" do
          before { @result = subject.parse("GS*first~AA*one~GS*second~BB*two~") }

          it "parses a correct string" do
            pending("Fixing loop processing") do
              @result.should == "GS*second~BB*two~"
            end
          end

          it "has one loop" do
            pending("Fixing loop processing") do
              subject.to_a.size.should == 1
            end
            subject[0].to_s.should == "GS*first~AA*one"
          end
        end
      end
    end

    context "on a complex loop" do
      context "with no repeat constraints" do
        let(:loop_a) { X12::Loop.new("LOOPA", [gs_segment, aa_segment], 1..999) }
        let(:loop_b) { X12::Loop.new("LOOPB", [gs_segment, bb_segment], 1..999) }

        # Loop: OUTER
        #   Loop: LOOPA
        #     Segment: GS
        #     Segment: AA
        #   Loop: LOOPB
        #     Segment: GS
        #     Segment: BB

        subject { X12::Loop.new("OUTER", [loop_a, loop_b], 1..2) }

        before { @result = subject.parse("GS*first~AA*aa~GS*second~BB*bb~") }

        it "parses a correct string" do
          # should not return anything because the string is finished
          @result.should == ""
        end

        it "has one loop A" do
          pending("Fixing loop processing") do
            subject.LOOPA.size.should == 1
          end
        end

        it "has one loop B" do
          subject.LOOPB.size.should == 1
        end

        it "completely parses LOOPA" do
          subject.LOOPA.to_s.should == "GS*first~AA*aa~"
        end

        it "completely parses LOOPB" do
          pending("Fixing loop processing") do
            subject.LOOPB.to_s.should == "GS*second~BB*bb~"
          end
        end
      end

      context "with repeat constraints allowing only one loop" do
        let(:loop_a) { X12::Loop.new("LOOPA", [gs_segment, aa_segment], 1..1) }
        let(:loop_b) { X12::Loop.new("LOOPB", [gs_segment, bb_segment], 1..1) }

        # Loop: OUTER
        #   Loop: LOOPA
        #     Segment: GS
        #     Segment: AA
        #   Loop: LOOPB
        #     Segment: GS
        #     Segment: BB

        subject { X12::Loop.new("OUTER", [loop_a, loop_b], 1..2) }

        before { @result = subject.parse("GS*first~AA*aa~GS*second~BB*bb~") }

        it "parses a correct string" do
          # should not return anything because the string is finished
          @result.should == ""
        end

        it "has one loop A" do
          subject.LOOPA.size.should == 1
        end

        it "has one loop B" do
          subject.LOOPB.size.should == 1
        end

        it "completely parses LOOPA" do
          subject.LOOPA.to_s.should == "GS*first~AA*aa~"
        end

        it "completely parses LOOPB" do
          subject.LOOPB.to_s.should == "GS*second~BB*bb~"
        end
      end

    end
  end

  describe "#render" do
  end


end
