require 'spec_helper'

describe "a 270 factory with interchange" do

  subject { X12::Parser.new('misc/270interchange.xml').factory('270interchange') }

  it "generates a 270 document" do
    subject.ISA {|isa|
      isa.AuthorizationInformationQualifier = '03'
      isa.AuthorizationInformation = 'user      '
      isa.SecurityInformationQualifier = '01'
      isa.SecurityInformation = 'password  '
      isa.InterchangeIdQualifier1 = 'ZZ'
      isa.InterchangeSenderId = '0000000Eliginet'
      isa.InterchangeIdQualifier2 = 'ZZ'
      isa.InterchangeReceiverId = 'CHICAGO BLUES'
      isa.InterchangeDate = '070724'
      isa.InterchangeTime = '1726'
      isa.InterchangeControlStandardsIdentifier = 'U'
      isa.InterchangeControlVersionNumber = '00401'
      isa.InterchangeControlNumber = '230623206'
      isa.AcknowledgmentRuested = '0'
      isa.UsageIndicator = 'T'
      isa.ComponentElementSeparator = ':'
    }

    fg_counter = 0
    subject.FG.repeat {|fg|
      create_fg(fg, fg_counter, 3)
      fg_counter += 1
    }

    subject.FG.repeat {|fg|
      create_fg(fg, fg_counter, 2)
      fg_counter += 1
    }

    subject.FG.repeat {|fg|
      create_fg(fg, fg_counter, 1)
      fg_counter += 1
    }

    subject.IEA {|iea|
      iea.NumberOfIncludedFunctionalGroups=fg_counter
      iea.InterchangeControlNumber = '230623206'
    }

    subject.render.should == document
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
IEA*3*230623206~
'.gsub(/\n/,'')
  end


  def create_270(message, fg_num, mess_num)
    transactionSetControlNumber = "#{fg_num}00#{mess_num}"
    count = 0

    message.ST.TransactionSetControlNumber  = transactionSetControlNumber
    count += 1

    message.BHT {|bht|
      bht.HierarchicalStructureCode='0022'
      bht.TransactionSetPurposeCode='13'
      bht.ReferenceIdentification='LNKJNFGRWDLR'
      bht.Date='20070724'
      bht.Time='1726'
    }
    count += 1

    message.L2000A {|l2000A|
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
          nm1.NameLastOrOrganizationName='RED CROSS'
          nm1.IdentificationCodeQualifier='PI'
          nm1.IdentificationCode='CHICAGO BLUES'
        }
        count += 1
      }
    }

    message.L2000B {|l2000B|
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

    message.L2000C {|l2000C|
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
          nm1.NameLastOrOrganizationName='LastName'
          nm1.NameFirst='FirstName'
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
    message.SE {|se|
      se.NumberOfIncludedSegments = count
      se.TransactionSetControlNumber = transactionSetControlNumber
    }

  end # create_270

  def create_fg(message, fg_num, num_of_270)
    groupControlNumber = "00#{fg_num}"

    message.GS {|gs|
      gs.FunctionalIdentifierCode='HS'
      gs.ApplicationSendersCode='0000000Eliginet'
      gs.ApplicationReceiversCode='CHICAGO BLUES'
      gs.Date='20070724'
      gs.Time='1726'
      gs.GroupControlNumber=groupControlNumber
      gs.ResponsibleAgencyCode='X'
      gs.VersionReleaseIndustryIdentifierCode='004010X092A1'
    }

    (1..num_of_270).each{|count|
      create_270(message._270.repeat, fg_num, count-1)
    }

    message.GE {|ge|
      ge.NumberOfTransactionSetsIncluded=num_of_270
      ge.GroupControlNumber=groupControlNumber
    }
  end # create_fg
  
  def test_all
  end # test_all

end # TestList
