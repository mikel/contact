require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  describe "Internal Membership handling (private methods)" do
    it "should add itself to the admin role" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.send(:add_role!, :admin)
      user.roles.should include(role)
    end

    it "should say if it is an admin" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.send(:add_role!, :admin)
      user.send(:member_of?, :admin).should be_true
    end
    
    it "should only add any role once" do
      user = Factory(:user)
      role = Factory(:admin_role)
      doing {
        user.send(:add_role!, :admin)
        user.send(:add_role!, :admin)
        user.send(:add_role!, :admin)
      }.should change(Membership, :count).by(1)
    end
    
    it "should raise an error if the role was not found" do
      user = Factory(:user)
      doing {user.send(:add_role!, :user)}.should raise_error(ActiveRecord::RecordNotFound, "Couldn't find Role with name = user")
    end
    
    it "should remove a role" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.send(:add_role!, :admin)
      doing { user.send(:remove_role!, :admin) }.should change(Membership, :count).by(-1)
      user.roles.should_not include(role)
    end
  end
  
  describe "membership helper methods " do
    it "should say it is an admin if it is" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.admin = true
      user.save!
      user.admin.should be_true
    end
    
    it "should handle integer strings passed into admin= for true" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.admin = "1"
      user.save
      user.admin.should be_true
    end
    
    it "should not allow you remove admin rights if it is the only admin" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.admin = true
      user.save
      user.admin = false
      user.save
      user.admin.should be_true
    end

    it "should handle integer strings passed into admin= for false" do
      # Setup another admin so we can remove the admin rights
      user2 = Factory(:user, :login => 'mr_admin')
      role2 = Factory(:admin_role)
      user2.admin = true
      user2.save

      user = Factory(:user)
      role = Factory(:admin_role)
      user.admin = true
      user.save
      user.admin = "0"
      user.save
      user.admin.should be_false
    end
    
    it "should say if it is the last admin if it is the only administrator user left" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.admin = true
      user.save
      user.should be_last_admin
    end
    
    it "should not say if it is the last admin if it is not the only administrator user left" do
      user1 = Factory(:user)
      user2 = Factory(:user, :login => 'sam')
      role = Factory(:admin_role)
      user1.admin = true
      user2.admin = true
      user1.save
      user2.save
      user1.should_not be_last_admin
      user2.should_not be_last_admin
    end
    
    it "should validate ok if it is the last admin in the system" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.admin = true
      user.should be_valid
    end
    
    it "should not validate ok if it is the last admin and trying to change to not an admin" do
      user = Factory(:user)
      role = Factory(:admin_role)
      user.admin = true
      user.save!
      user.admin = false
      user.should_not be_valid
    end
  end
  
  describe "mass assignment protection" do
    it "should not allow you to mass assign the login" do
      user = User.new({:login => 'bob'})
      user.login.should be_nil
    end

    it "should not allow you to mass assign the admin" do
      user = User.new({:admin => true})
      user.admin.should_not be_true
    end

    it "should allow you to mass assign the login" do
      user = User.new({:given_name => 'mikel'})
      user.given_name.should == 'mikel'
    end
  end
  
  describe "template association" do
    it "should have many templates" do
      user = Factory(:user)
      email_template = Factory(:email_template)
      doing { user.email_templates << email_template }.should_not raise_error
    end
    
    it "should have an templates" do
      user = Factory(:user)
      email_template = Factory(:email_template)
      user.email_templates << email_template
      user.email_templates.should include(email_template)
    end
  end
  
  describe "organization association" do
    it "should belong to an organization" do
      user = Factory(:user)
      organization = Factory(:organization)
      doing { user.organization = organization }.should_not raise_error
    end
    
    it "should have an organization" do
      user = Factory(:user)
      organization = Factory(:organization)
      user.organization = organization
      user.organization.should == organization
    end
    
    it "should be invalid without an organization" do
      user = Factory(:user)
      user.organization = nil
      user.organization_id = nil
      user.should_not be_valid
    end
  end
  
  describe "recipients association through organizations" do
    it "should have a proxy association to recipients that references the organziation" do
      organization = Factory(:organization)
      user = Factory(:user, :organization => organization)
      recipient = Factory(:recipient, :organization => organization)
      user.recipients.should include(recipient)
    end
  end
  
end
