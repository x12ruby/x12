require 'spec_helper'

describe "a 997 document" do
  subject { X12::Parser.new('misc/270.xml').parse('270', document) }

  it "tests ST" do
    subject.ST.to_s.should == 'ST*270*1001~'
    subject.ST.TransactionSetIdentifierCode.should == '270'
  end # test_ST

  it "tests L2000A_NM1" do
    subject.L2000A.L2100A.NM1.NameLastOrOrganizationName.should == 'BIG PAYOR'
  end

  it "tests L2000C_NM1" do
    subject.L2000C.L2100C.NM1.NameFirst.should == 'Joe'
  end

  it "tests L2000A_HL" do
    subject.L2000A.HL.HierarchicalParentIdNumber.should == ''
  end

  it "tests absent" do
    subject.L2000D.HHH.should == X12::EMPTY
    subject.L2000B.L2111.should == X12::EMPTY
    subject.L2000C.L2100C.N3.AddressInformation1.should == ''
  end # test_absent

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
SE*12*1001~
'.gsub(/\n/,'')
  end

end # TestParse
