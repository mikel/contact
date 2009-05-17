require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Membership do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :role_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Membership.create!(@valid_attributes)
  end
  
  it "should add a given membership to a user" do
    user = Factory(:user)
    Membership.should respond_to(:add_membership!)
  end
  
end
