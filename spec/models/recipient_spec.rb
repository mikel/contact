require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recipient do

  describe "black listing" do
    it "should allow itself to black listed" do
      recipient = Factory(:recipient)
      doing { recipient.black_list! }.should_not raise_error
    end
    
    it "should say it is black listed" do
      recipient = Factory(:recipient)
      recipient.black_list!
      recipient.black_list.should be_true
    end
  end

  describe "organization association" do
    it "should belong to an organization" do
      recipient = Factory(:recipient)
      organization = Factory(:organization)
      doing { recipient.organization = organization }.should_not raise_error
    end
    
    it "should have an organization" do
      recipient = Factory(:recipient)
      organization = Factory(:organization)
      recipient.organization = organization
      recipient.organization.should == organization
    end
    
    it "should be invalid without an organization" do
      recipient = Factory(:recipient)
      recipient.organization = nil
      recipient.should_not be_valid
    end
  end

  describe "helper methods" do
    it "should give the name as the given and family names" do
      recipient = Factory(:recipient)
      recipient.given_name = 'Mikel'
      recipient.family_name = 'Lindsaar'
      recipient.name.should == 'Mikel Lindsaar'
    end
  end

end
