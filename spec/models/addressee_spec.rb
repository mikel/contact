require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Addressee do
  
  it "should belong to a recipient" do
    @addressee = Addressee.new
    @mailout = Mailout.new
    @addressee.mailout = @mailout
    @addressee.mailout.should == @mailout
  end
  
  it "should belong to a recipient" do
    @addressee = Addressee.new
    @recipient = Recipient.new
    @addressee.recipient = @recipient
    @addressee.recipient.should == @recipient
  end
  
  it "should belong to a group" do
    @addressee = Addressee.new
    @group = Group.new
    @addressee.group = @group
    @addressee.group.should == @group
  end
  
end
