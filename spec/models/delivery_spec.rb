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

  describe "providing unique URLs for each delivery" do
    
    it "should provide a hash for each user" do
      delivery = Delivery.new(:user_id      => 1,
                              :recipient_id => 2,
                              :mailout_id   => 3)
      delivery.unique_path.should_not be_blank
    end
    
    it "should provide a unique path that is URL safe" do
      delivery = Delivery.new(:user_id      => 1,
                              :recipient_id => 2,
                              :mailout_id   => 3)
      (delivery.unique_path =~ /[\\\/\s]/).should be_nil
    end
    
    it "should provide an unique hash" do
      delivery1 = Delivery.new(:user_id      => 1,
                               :recipient_id => 2,
                               :mailout_id   => 3)
      delivery2 = Delivery.new(:user_id      => 1,
                               :recipient_id => 3,
                               :mailout_id   => 3)
      delivery1.unique_path.should_not == delivery2.unique_path
    end
    
    it "should be able return the delivery from a supplied path" do
      delivery = Delivery.create(:user_id      => 1,
                                 :recipient_id => 2,
                                 :mailout_id   => 3)
      found = Delivery.for(delivery.unique_path)
      found.should == delivery
    end
  end

end
