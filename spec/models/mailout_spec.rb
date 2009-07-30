require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mailout do

  def valid_attributes
    { :title => "New Mailout",
      :message_id => 3 }
  end
  
  def new_mailout(args = {})
    Mailout.new(valid_attributes.merge!(args))
  end
  
  describe "validations" do
    it "should be valid with valid params" do
      @mailout = new_mailout
      @mailout.should be_valid
    end
    
    it "should be invalid without a title" do
      @mailout = new_mailout(:title => nil)
      @mailout.should_not be_valid
    end
    
    it "should be invalid without an associated message" do
      @mailout = new_mailout(:message_id => nil)
      @mailout.should_not be_valid
    end
  end
  
  describe "associations" do
    
    it "should belong to a user" do
      @mailout = Mailout.new
      @User = User.new
      @mailout.user = @user
      @mailout.user.should == @user
    end
    
    it "should have many recipients through addressees" do
      @mailout = Mailout.new
      @recipient = Recipient.new
      @mailout.recipients << @recipient
      @mailout.recipients.should include(@recipient)
    end
    
    it "should have many groups through addressees" do
      @mailout = Mailout.new
      @group = Group.new
      @mailout.groups << @group
      @mailout.groups.should include(@group)
    end
    
    it "should have an organization via user" do
      @org = Factory(:organization)
      @user = Factory(:user, :organization => @org)
      @mailout = Mailout.new(:user => @user)
      @mailout.organization.should == @org
    end
    
    it "should belong to a message" do
      @mailout = Mailout.new
      @message = Message.new
      @mailout.message = @message
      @mailout.message.should == @message
    end
  end
  
  describe "helper for adding a group individually" do
    it "should have the virtual attribute :add_group_id" do
      @mailout = Mailout.new
      @mailout.should respond_to(:add_group_id)
    end

    it "should have the virtual attribute :add_group_id=" do
      @mailout = Mailout.new
      @mailout.should respond_to(:add_group_id=)
    end
    
    it "should make an addressee off the group id" do
      @mailout = Mailout.new
      @mailout.id = 10
      @group = mock_model(Group, :valid? => true)
      Group.stub!(:find).and_return(@group)
      @mailout.add_group_id = 5
      @mailout.groups.should include(@group)
      
    end
  end

  describe "helper for adding a recipient individually" do
    it "should have the virtual attribute :add_recipient" do
      @mailout = Mailout.new
      @mailout.should respond_to(:add_recipient)
    end

    it "should have the virtual attribute :add_recipient=" do
      @mailout = Mailout.new
      @mailout.should respond_to(:add_recipient=)
    end
    
    it "should find the recipient of email address if given an email address" do
      @mailout = Mailout.new
      @mailout.id = 10
      Recipient.should_receive(:find).with(:first, :conditions => {:email => 'mikel@me.com'})
      Addressee.stub!(:create!)
      @mailout.add_recipient = 'mikel@me.com'
    end
    
    it "should find the recipient off given and family name if given a given and family name" do
      @mailout = Mailout.new
      @mailout.id = 10
      Recipient.should_receive(:find).with(:first, :conditions => {:given_name => 'Mikel', :family_name => "Lindsaar"})
      @mailout.add_recipient = 'Mikel Lindsaar'
    end

    it "should create the subscription with the found recipient id" do
      @mailout = Mailout.new
      @mailout.id = 10
      @recipient = mock_model(Recipient)
      Recipient.stub!(:find).and_return(@recipient)
      @mailout.add_recipient = 'Mikel Lindsaar'
      @mailout.recipients.should include(@recipient)
    end
    
    it "should not try adding an addressee if no recipient was found" do
      @mailout = Mailout.new
      @mailout.id = 10
      Recipient.stub!(:find).and_return(nil)
      doing { @mailout.add_recipient = 'Mikel Lindsaar' }.should_not raise_error
    end
    
    it "should not try to add a recipient if none was given" do
      @mailout = Mailout.new
      @mailout.id = 10
      doing { @mailout.add_recipient = '' }.should_not raise_error
    end
    
    it "should not try to add a group if none was given" do
      @mailout = Mailout.new
      @mailout.id = 10
      doing { @mailout.add_group_id = '' }.should_not raise_error
    end
    
    it "should add an error to base if no recipient was found" do
      @mailout = new_mailout(:aasm_state => 'select_recipients')
      Recipient.stub!(:find).and_return(nil)
      @mailout.add_recipient = 'Mikel Lindsaar'
      @mailout.next!
      @mailout.errors.full_messages.should include("No recipient found with 'Mikel Lindsaar'")
    end
    
    it "should say 'Please select at least one recipient' if there are no recipients or groups selected already and nothing is passed in" do
      @mailout = new_mailout(:aasm_state => 'select_recipients')
      Recipient.stub!(:find).and_return(nil)
      @mailout.add_recipient = ''
      @mailout.next!
      @mailout.errors.full_messages.should include("Please select at least one recipient")
    end
    
  end

  describe "state transitions using next!" do
    it "should transition from schedule_mailout to confirm_mailout" do
      @mailout = new_mailout(:aasm_state => "new")
      @mailout.next!
      @mailout.state.should == "select_recipients"
    end
    
    it "should transition from select_recipients to select_recipients once we add one recipient" do
      @mailout = new_mailout
      @mailout.aasm_state = 'select_recipients'
      @recipient = Factory(:recipient, :email => "mikel@me.com")
      @mailout.add_recipient = @recipient.email
      @mailout.next!
      @mailout.state.should == "select_recipients"
    end

    it "should transition from select_recipients to schedule_mailout only if we have finished selecting recipients" do
      @mailout = new_mailout
      @mailout.aasm_state = 'select_recipients'
      @recipient = Factory(:recipient, :email => "mikel@me.com")
      @mailout.add_recipient = @recipient.email
      @mailout.next!
      @mailout = Mailout.find(@mailout.id)
      @mailout.next!
      @mailout.state.should == "schedule_mailout"
    end

    it "should transition from schedule_mailout to confirm_mailout" do
      @mailout = new_mailout(:aasm_state => "schedule_mailout")
      @mailout.next!
      @mailout.state.should == "confirm_mailout"
    end

    it "should transition from confirm_mailout to confirmed" do
      @mailout = new_mailout(:aasm_state => "confirm_mailout")
      @mailout.next!
      @mailout.state.should == "confirmed"
    end
  end

  describe "state transitions using previous!" do
    
    it "should transition to confirm_mailout from confirmed" do
      @mailout = new_mailout(:aasm_state => "confirmed")
      @mailout.previous!
      @mailout.state.should == "confirm_mailout"
    end
    
    it "should transition to schedule_mailout from confirm_mailout" do
      @mailout = new_mailout(:aasm_state => "confirm_mailout")
      @mailout.previous!
      @mailout.state.should == "schedule_mailout"
    end
    
    it "should transition to select_recipients from schedule_mailout" do
      @mailout = new_mailout(:aasm_state => "schedule_mailout")
      @mailout.previous!
      @mailout.state.should == "select_recipients"
    end
    
    it "should transition to new from select_recipients" do
      @mailout = new_mailout(:aasm_state => "select_recipients")
      @mailout.previous!
      @mailout.state.should == "new"
    end

  end

end
