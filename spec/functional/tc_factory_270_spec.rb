require 'spec_helper'

describe "a 270 factory" do

  subject { X12::Parser.new('misc/270.xml').factory('270') }

  it "generates the right document" do
    count = 0

    subject.ST.TransactionSetControlNumber  = '1001'
    count += 1

    subject.BHT {|bht|
      bht.HierarchicalStructureCode='0022'
      bht.TransactionSetPurposeCode='13'
      bht.ReferenceIdentification='LNKJNFGRWDLR'
      bht.Date='20070724'
      bht.Time='1726'
    }
    count += 1

    subject.L2000A {|l2000A|
      l2000A.HL{|hl|
        hl.HierarchicalIdNumber='1'
        hl.HierarchicalParentIdNumber=''
        hl.HierarchicalChildCode='1'
      }
      count += 1

      l2000A.L2100A {|l2100A|
        l2100A.NM1 {|nm1|
          nm1.EntityIdentifierCode1='PR'
          nm1.EntityTypeQualifier='2'
          nm1.NameLastOrOrganizationName='BIG PAYOR'
          nm1.IdentificationCodeQualifier='PI'
          nm1.IdentificationCode='CHICAGO BLUES'
        }
        count += 1
      }
    }

    subject.L2000B {|l2000B|
      l2000B.HL{|hl|
        hl.HierarchicalIdNumber='2'
        hl.HierarchicalParentIdNumber='1'
        hl.HierarchicalChildCode='1'
      }
      count += 1

      l2000B.L2100B {|l2100B|
        l2100B.NM1 {|nm1|
          nm1.EntityIdentifierCode1='1P'
          nm1.EntityTypeQualifier='1'
          nm1.NameLastOrOrganizationName=''
          nm1.IdentificationCodeQualifier='SV'
          nm1.IdentificationCode='daw'
        }
        count += 1
      }
    }

    subject.L2000C {|l2000C|
      l2000C.HL{|hl|
        hl.HierarchicalIdNumber='3'
        hl.HierarchicalParentIdNumber='2'
        hl.HierarchicalChildCode='0'
      }
      count += 1

      l2000C.L2100C {|l2100C|
        l2100C.NM1 {|nm1|
          nm1.EntityIdentifierCode1='IL'
          nm1.EntityTypeQualifier='1'
          nm1.NameLastOrOrganizationName='Doe'
          nm1.NameFirst='Joe'
        }
        count += 1

        l2100C.DMG {|dmg|
          dmg.DateTimePeriodFormatQualifier='D8'
          dmg.DateTimePeriod='19700725'
        }
        count += 1

        l2100C.DTP {|dtp|
          dtp.DateTimeQualifier='307'
          dtp.DateTimePeriodFormatQualifier='D8'
          dtp.DateTimePeriod='20070724'
        }
        count += 1

        l2100C.L2110C {|l2110C|
          l2110C.EQ {|eq|
            eq.ServiceTypeCode='60'
          }
          count += 1
        }
      }
    }

    count += 1
    subject.SE {|se|
      se.NumberOfIncludedSegments = count
      se.TransactionSetControlNumber = '1001'
    }

    subject.render.should == document
  end

  def document
'ST*270*1001~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*BIG PAYOR*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*Doe*Joe~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*1001~'.gsub(/\n/, "")
  end
end
