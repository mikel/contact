require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Delivery do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Delivery.create!(@valid_attributes)
  end
  
  describe "associations" do
    it "should belong to a mailout" do
      @delivery = Delivery.new
      @mailout = Mailout.new
      @delivery.mailout = @mailout
      @delivery.mailout.should == @mailout
    end

    it "should belong to a recipient" do
      @delivery = Delivery.new
      @recipient = Recipient.new
      @delivery.recipient = @recipient
      @delivery.recipient.should == @recipient
    end

    it "should belong to a user" do
      @delivery = Delivery.new
      @user = User.new
      @delivery.user = @user
      @delivery.user.should == @user
    end
  end
end
