require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  describe "memberships interface" do
    it "should add itself to the admin role" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.add_role!(:admin)
      user.roles.should include(role)
    end

    it "should say if it is an admin" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.add_role!(:admin)
      user.member_of?(:admin).should be_true
    end
    
    it "should raise an error if the role was not found" do
      user = Factory(:user)
      doing {user.add_role!(:user)}.should raise_error(ActiveRecord::RecordNotFound, "Couldn't find Role with name = user")
    end
    
  end
  
end
