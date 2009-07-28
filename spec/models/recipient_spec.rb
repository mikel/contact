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
      @message = Message.new
      @recipient.messages << @message
      @recipient.messages.should include(@message)
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

end
