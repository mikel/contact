require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sender do
  before(:each) do
    @valid_attributes = {
      :name => "Org",
      :from => "org@test.lindsaar.net",
      :reply_to => "no_reply@test.lindsaar.net",
      :organization_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Sender.create!(@valid_attributes)
  end
  
  describe "associations" do
    it "should belong to an organization" do
      @org = Organization.new
      @sender = Sender.new
      @sender.organization = @org
      @sender.organization.should == @org
    end

    it "should have many mailouts" do
      @mailout = Mailout.new
      @sender = Sender.new
      @sender.mailouts << @mailout
      @sender.mailouts.should include(@mailout)
    end

  end
end
