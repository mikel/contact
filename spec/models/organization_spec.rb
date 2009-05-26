require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Organization do

  describe "user association" do
    it "should have many users" do
      organization = Factory(:organization)
      user = Factory(:user, :organization => organization)
      organization.users.should include(user)
    end
  end

  describe "recipient association" do
    it "should have many recipients" do
      organization = Factory(:organization)
      recipient = Factory(:recipient, :organization => organization)
      organization.recipients.should include(recipient)
    end
  end

end
