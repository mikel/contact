require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Group do

  describe "associations" do
    it "should belong to a user" do
      @group = Group.new
      doing { @group.user = User.new }.should_not raise_error
    end
    
    it "should have many recipients" do
      @group = Factory(:group)
      @recipient = Factory(:recipient)
      doing { @group.recipients << @recipient }.should_not raise_error
    end
    
    it "should have many messages through addressees" do
      @group = Group.new
      @mailout = Mailout.new
      @group.mailouts << @mailout
      @group.mailouts.should include(@mailout)
    end
    
  end

end
