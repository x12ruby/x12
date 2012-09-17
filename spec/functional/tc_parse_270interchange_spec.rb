require 'spec_helper'

describe "a 270 document with interchange" do
  subject { X12::Parser.new('misc/270interchange.xml').parse('270interchange', document) }

  it "tests ISA_IEA" do
    subject.ISA.to_s.should == 'ISA*03*user      *01*password  *ZZ*0000000Eliginet*ZZ*CHICAGO BLUES*070724*1726*U*00401*230623206*0*T*:~'
    subject.ISA.InterchangeSenderId.should == '0000000Eliginet'
    subject.IEA.NumberOfIncludedFunctionalGroups.should == '3'

  end # test_ST

  it "tests FG" do
    fg = subject.FG
    fg.to_a.size.should == 3
    fg.size.should == 3
    fg[0].find('270').to_a.size.should == 3
    fg[1].find('270').size.should == 2
    fg[2]._270.size.should == 1
    fg[0].GE.NumberOfTransactionSetsIncluded.should == '3'
    fg[1].GE.GroupControlNumber.should == '001'
    fg[2].GS.GroupControlNumber.should == '002'
  end

  it "tests ST" do
    subject.FG[1]._270[1].ST.to_s.should == 'ST*270*1001~'
    subject.FG[1]._270[1].ST.TransactionSetIdentifierCode.should == '270'
  end # test_ST

  it "tests L2000A_NM1" do
    subject.FG[1]._270[1].L2000A.L2100A.NM1.NameLastOrOrganizationName.should == 'RED CROSS'
  end

  it "tests L2000C_NM1" do
    subject.FG[1].with { |fg|
      fg._270[1].with {|_270|
        _270.L2000C {|l2000C|
          l2000C.L2100C {|l2100C|
            l2100C.NM1 {|nm1|
              nm1.NameFirst.should == 'FirstName'
            }
          }
        }
      }
    }
  end

  it "tests L2000A_HL" do
    subject.FG[1]._270[1].L2000A.HL.HierarchicalParentIdNumber.should == ''
  end

  def document
'ISA*03*user      *01*password  *ZZ*0000000Eliginet*ZZ*CHICAGO BLUES*070724*1726*U*00401*230623206*0*T*:~
GS*HS*0000000Eliginet*CHICAGO BLUES*20070724*1726*000*X*004010X092A1~
ST*270*0000~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*0000~
ST*270*0001~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*0001~
ST*270*0002~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*0002~
GE*3*000~
GS*HS*0000000Eliginet*CHICAGO BLUES*20070724*1726*001*X*004010X092A1~
ST*270*1000~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*1000~
ST*270*1001~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*1001~
GE*2*001~
GS*HS*0000000Eliginet*CHICAGO BLUES*20070724*1726*002*X*004010X092A1~
ST*270*2000~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*RED CROSS*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*LastName*FirstName~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*2000~
GE*1*002~
IEA*3*230623206~'.gsub(/\n/,'')
  end


end # TestParse
