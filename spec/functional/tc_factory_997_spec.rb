require 'spec_helper'

describe "a 997 factory" do

  subject { X12::Parser.new('misc/997.xml').factory('997') }

  it "generates the right document" do
    subject.ST.TransactionSetIdentifierCode = 997
    subject.ST.TransactionSetControlNumber  = '2878'

    subject.AK1 { |ak1|
      ak1.FunctionalIdentifierCode = 'HS'
      ak1.GroupControlNumber       = 293328532
    }

    subject.L1000.L1010.AK4.DataElementSyntaxErrorCode=55
    subject.L1000.AK2.TransactionSetIdentifierCode = 270
    subject.L1000.L1010 {|l|
      l.AK3 {|s|
        s.SegmentIdCode                   = 'NM1'
        #SegmentPositionInTransactionSet
        s.LoopIdentifierCode              = 'L1000D'
        #SegmentSyntaxErrorCode
      }

      l.AK4 {|s|
        #s.PositionInSegment =
        #s.DataElementReferenceNumber =
        #s.DataElementSyntaxErrorCode = 
        s.CopyOfBadDataElement       = 'Bad element'
      }
    }

    subject.L1000.AK5{|a|
      a.TransactionSetAcknowledgmentCode = 'A'
    } # a

    # Should be two repeats in total
    subject.L1000.repeat {|l1000|
      (0..1).each {|loop_repeat| # Two repeats of the loop L1010
        l1000.L1010.repeat {|l1010|

          l1010.AK3 {|s|
            s.SegmentIdCode                   = 'DMG'
            s.SegmentPositionInTransactionSet = 0
            s.LoopIdentifierCode              = 'L1010'
            s.SegmentSyntaxErrorCode          = 22
          } if loop_repeat == 0 # AK3 only in the first repeat of L1010

          (0..1).each {|ak4_repeat| # Two repeats of the segment AK4
            l1010.AK4.repeat {|s|
              s.PositionInSegment          = loop_repeat
              #s.DataElementReferenceNumber = 
              s.DataElementSyntaxErrorCode = ak4_repeat
              #s.CopyOfBadDataElement       =
            } # s
          } # ak4_repeat
        } # l1010
      } # loop_repeat

      l1000.AK5{|a|
        a.TransactionSetAcknowledgmentCode = 'E'
        a.TransactionSetSyntaxErrorCode4 = 999
      } # a
    } # l1000

    subject.render.should == document
  end

  def document
'ST*997*2878~
AK1*HS*293328532~
AK2*270*~
AK3*NM1**L1000D~
AK4***55*Bad element~
AK5*A~
AK3*DMG*0*L1010*22~
AK4*0**0~
AK4*0**1~
AK4*1**0~
AK4*1**1~
AK5*E****999~
AK9****~
SE**~'.gsub(/\n/,'')
  end

end # TestList
