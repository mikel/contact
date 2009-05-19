require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailTemplate do
  
  describe "validations" do
    it "should require a title" do
      template = Factory.build(:email_template)
      template.title = nil
      template.should_not be_valid
    end

    it "should require a body" do
      template = Factory.build(:email_template)
      template.body = nil
      template.should_not be_valid
    end
  end
  
  describe "associations" do
    it "should belong to a user" do
      template = EmailTemplate.new
      template.user = User.new
      template.user.should_not be_nil
    end
  end
  
end
