require 'spec_helper'

describe "a 270 factory" do

  subject { X12::Parser.new('misc/270.xml').factory('270') }

  it "generates the right document" do
    count = 0

    subject.ST.TransactionSetControlNumber  = '1001'
    count += 1

    subject.BHT do |bht|
      bht.HierarchicalStructureCode='0022'
      bht.TransactionSetPurposeCode='13'
      bht.ReferenceIdentification='LNKJNFGRWDLR'
      bht.Date='20070724'
      bht.Time='1726'
    end
    count += 1

    subject.L2000A do |l2000A|
      l2000A.HL do |hl|
        hl.HierarchicalIdNumber='1'
        hl.HierarchicalParentIdNumber=''
        hl.HierarchicalChildCode='1'
      end
      count += 1

      l2000A.L2100A do |l2100A|
        l2100A.NM1 do |nm1|
          nm1.EntityIdentifierCode1='PR'
          nm1.EntityTypeQualifier='2'
          nm1.NameLastOrOrganizationName='BIG PAYOR'
          nm1.IdentificationCodeQualifier='PI'
          nm1.IdentificationCode='CHICAGO BLUES'
        end
        count += 1
      end
    end

    subject.L2000B do |l2000B|
      l2000B.HL do |hl|
        hl.HierarchicalIdNumber='2'
        hl.HierarchicalParentIdNumber='1'
        hl.HierarchicalChildCode='1'
      end
      count += 1

      l2000B.L2100B do |l2100B|
        l2100B.NM1 do |nm1|
          nm1.EntityIdentifierCode1='1P'
          nm1.EntityTypeQualifier='1'
          nm1.NameLastOrOrganizationName=''
          nm1.IdentificationCodeQualifier='SV'
          nm1.IdentificationCode='daw'
        end
        count += 1
      end
    end

    subject.L2000C do |l2000C|
      l2000C.HL do |hl|
        hl.HierarchicalIdNumber='3'
        hl.HierarchicalParentIdNumber='2'
        hl.HierarchicalChildCode='0'
      end
      count += 1

      l2000C.L2100C do |l2100C|
        l2100C.NM1 do |nm1|
          nm1.EntityIdentifierCode1='IL'
          nm1.EntityTypeQualifier='1'
          nm1.NameLastOrOrganizationName='Doe'
          nm1.NameFirst='Joe'
        end
        count += 1

        l2100C.DMG do |dmg|
          dmg.DateTimePeriodFormatQualifier='D8'
          dmg.DateTimePeriod='19700725'
        end
        count += 1

        l2100C.DTP do |dtp|
          dtp.DateTimeQualifier='307'
          dtp.DateTimePeriodFormatQualifier='D8'
          dtp.DateTimePeriod='20070724'
        end
        count += 1

        l2100C.L2110C do |l2110C|
          l2110C.EQ  do |eq|
            eq.ServiceTypeCode='60'
          end
          count += 1
        end
      end
    end

    count += 1
    subject.SE do |se|
      se.NumberOfIncludedSegments = count
      se.TransactionSetControlNumber = '1001'
    end

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
