require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recipient do

  describe "validations" do
    it "should require an email address" do
      recipient = Factory(:recipient)
      recipient.email = nil
      recipient.should_not be_valid
    end

    it "should require a real email address" do
      recipient = Factory(:recipient)
      recipient.email = ''
      recipient.should_not be_valid
    end
  end

  describe "associations" do
    it "should have many deliveries" do
      @recipient = Recipient.new
      @delivery = Delivery.new
      @recipient.deliveries << @delivery
      @recipient.deliveries.should include(@delivery)
    end
  end

  describe "black listing" do
    it "should allow itself to black listed" do
      recipient = Factory(:recipient)
      doing { recipient.black_list! }.should_not raise_error
    end
    
    it "should say it is black listed" do
      recipient = Factory(:recipient)
      recipient.black_list!
      recipient.should be_black_listed
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

  describe "group association" do
    it "should have many groups" do
      recipient = Factory(:recipient)
      group = Factory(:group)
      doing { recipient.groups << group }.should_not raise_error
    end
  end
  
  describe "message association" do
    it "should have many messages through addressees" do
      @recipient = Recipient.new
      @mailout = Mailout.new
      @recipient.mailouts << @mailout
      @recipient.mailouts.should include(@mailout)
    end
  end  

  describe "helper methods" do
    it "should give the name as the given and family names" do
      recipient = Factory(:recipient)
      recipient.given_name = 'Mikel'
      recipient.family_name = 'Lindsaar'
      recipient.name.should == 'Mikel Lindsaar'
    end
    
    it "should add a group when given an id to add_group_id" do
      recipient = Factory(:recipient)
      group = Factory(:group)
      doing { recipient.add_group_id=(group.id) }.should change(recipient.groups, :count).by(1)
    end
    
    it "should do nothing on add_group_id = if passed a null or nil value" do
      recipient = Factory(:recipient)
      doing { recipient.add_group_id=(nil) }.should_not raise_error
    end
    
    it "should report nil to :add_group_id" do
      Factory(:recipient).add_group_id.should be_nil
    end
  end

  describe "handling domain information" do
    it "should set the domain field when the email address is assigned" do
      recipient = Factory(:recipient, {:email => 'mikel@test.lindsaar.net.au'})
      recipient.save!
      recipient.domain.should == 'test.lindsaar.net.au'
    end

    it "should set the domain field when a complex email address is assigned" do
      recipient = Factory(:recipient, {:email => '"Mikel Lindsaar" <mikel@test.lindsaar.net.au>'})
      recipient.save!
      recipient.domain.should == 'test.lindsaar.net.au'
    end
  end

end
