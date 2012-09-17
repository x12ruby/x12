require 'spec_helper'

describe "a 997 document" do
  subject { X12::Parser.new('misc/997.xml').parse('997', a_997_document) }

  it "parses the ST segment" do
    subject.ST.to_s.should == "ST*997*2878~"
    subject.ST.TransactionSetIdentifierCode.should == "997"
  end

  it "tests AK1" do
    subject.AK1.GroupControlNumber.should == '293328532'
  end # test_AK1

  it "tests AK2" do
    subject.L1000.AK2.TransactionSetIdentifierCode.should == '270'
  end # test_AK2

  it "tests L1010" do
    subject.L1000.L1010.to_s.should =~ /L1010_0/
    subject.L1000.L1010.to_a.size.should == 3
    subject.L1000.L1010.size.should == 3
    subject.L1000.L1010.to_a[2].to_s.should =~ /L1010_2/
    subject.L1000.L1010[2].to_s.should =~ /L1010_2/
  end # test_L1010

  it "tests AK4" do
    subject.L1000.L1010.to_a[1].AK4.to_s.should == 'AK4*1:0*66*1~'
    subject.L1000.L1010[1].AK4.to_s.should == 'AK4*1:0*66*1~'
    subject.L1000.L1010.AK4.to_a.size.should == 3
    subject.L1000.L1010.AK4.size.should == 3
    subject.L1000.L1010.to_a[1].AK4.to_a.size.should == 2
    subject.L1000.L1010[1].AK4.size.should == 2
    subject.L1000.L1010.to_a[1].AK4.to_a[1].to_s.should == 'AK4*1:1*66*1~'
    subject.L1000.L1010[1].AK4[1].to_s.should == 'AK4*1:1*66*1~'
    subject.L1000.L1010.AK4.DataElementReferenceNumber.should == '66'
  end # test_AK4

  it "tests absent" do
    subject.L1000.AK8.TransactionSetIdentifierCode.should == X12::EMPTY
    subject.L1000.L1111.should == X12::EMPTY
    subject.L1000.L1111.L2222.should == X12::EMPTY
    subject.L1000.L1111.L2222.AFAFA.should == X12::EMPTY
    subject.L1000.L1010[-99].should == X12::EMPTY
    subject.L1000.L1010[99].should == X12::EMPTY
    subject.L1000.L1010[99].AK4.should == X12::EMPTY

    subject.L1000.AK8.TransactionSetIdentifierCode.to_s.should == ''
  end # test_absent

  def a_997_document
'ST*997*2878~
AK1*HS*293328532~
AK2*270*307272179~
AK3*NM1*8*L1010_0*8~
AK4*0:0*66*1~
AK4*0:1*66*1~
AK4*0:2*66*1~
AK3*NM1*8*L1010_1*8~
AK4*1:0*66*1~
AK4*1:1*66*1~
AK3*NM1*8*L1010_2*8~
AK4*2:0*66*1~
AK5*R*5~
AK9*R*1*1*0~
SE*8*2878~
'.gsub(/\n/, "")
  end
end
