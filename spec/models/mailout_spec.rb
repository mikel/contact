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
    
    it "should belong to a sender" do
      @mailout = Mailout.new
      @sender = Sender.new
      @mailout.sender = @sender
      @mailout.sender.should == @sender
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

    it "should transition from confirmed to sent" do
      @mailout = new_mailout(:aasm_state => "confirmed")
      @mailout.next!
      @mailout.state.should == "sent"
    end
  end

  describe "state transitions using previous!" do
    
    it "should transition to confirmed from sent" do
      @mailout = new_mailout(:aasm_state => "sent")
      @mailout.previous!
      @mailout.state.should == "confirmed"
    end
    
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

  describe "ready to send scope" do
    
    it "should return an email that is confirmed and past it's sent schedule date" do
      mailout = Factory(:mailout, :date_scheduled => 1.day.ago, :aasm_state => 'confirmed')
      Mailout.ready_to_send.should include(mailout)
    end
    
    it "should not return an email that is past it's sent schedule date but not confirmed" do
      mailout = Factory(:mailout, :date_scheduled => 1.day.ago, :aasm_state => 'confirm_mailout')
      Mailout.ready_to_send.should_not include(mailout)
    end
    
    it "should not return an email that is confirmed but not past it's sent schedule date" do
      mailout = Factory(:mailout, :date_scheduled => 1.day.from_now, :aasm_state => 'confirmed')
      Mailout.ready_to_send.should_not include(mailout)
    end

  end

  describe "getting a list of addressees" do
    it "should return a list of people who will be sent an email" do
      doing { Factory(:mailout).subscribers }.should_not raise_error
    end
    
    it "should include any recipients in it's subscriber list" do
      mailout = Factory(:mailout)
      mikel = Factory(:recipient, :email => "mikel@test.lindsaar.net")
      ada = Factory(:recipient, :email => "ada@test.lindsaar.net")
      mailout.recipients << mikel
      mailout.recipients << ada
      mailout.recipients.length.should == 2
      mailout.subscribers.should include(mikel)
      mailout.subscribers.should include(ada)
      mailout.subscribers.length.should == 2
    end
    
    it "should include any groups in it's subscriber list" do
      mailout = Factory(:mailout)
      mikel = Factory(:recipient, :email => "mikel@test.lindsaar.net")
      ada = Factory(:recipient, :email => "ada@test.lindsaar.net")
      group = Factory(:group)
      group.recipients << mikel
      group.recipients << ada
      mailout.groups << group
      mailout.subscribers.should include(mikel)
      mailout.subscribers.should include(ada)
      mailout.subscribers.length.should == 2
    end
    
    it "should only include each recipient once" do
      mailout = Factory(:mailout)
      mikel = Factory(:recipient, :email => "mikel@test.lindsaar.net")
      group = Factory(:group)
      group.recipients << mikel
      mailout.groups << group
      mailout.recipients << mikel
      mailout.subscribers.should include(mikel)
      mailout.subscribers.length.should == 1
    end
    
    it "should find all subscribers for the mailout, but order them by domain" do
      mailout = Factory(:mailout)
      mikel = Factory(:recipient, :email => "mikel@test.lindsaar.net")
      sam = Factory(:recipient, :email => "mikel@gmail.com")
      ada = Factory(:recipient, :email => "ada@test.lindsaar.net")
      group = Factory(:group)
      group.recipients << mikel
      group.recipients << sam
      mailout.recipients << ada
      mailout.groups << group
      mailout.subscribers.should == [sam, mikel, ada]
    end
    
    it "should not find anyone we have already delivered a mailout to" do
      mailout = Factory(:mailout)
      sam = Factory(:recipient, :email => "mikel@gmail.com")
      ada = Factory(:recipient, :email => "ada@test.lindsaar.net")
      mailout.recipients << ada
      mailout.recipients << sam
      Delivery.create(:recipient => sam, :mailout => mailout, :user => User.find(:first))
      mailout.subscribers.should == [ada]
    end
    
  end

  describe "sender relationship" do
    it "should give it's sender's from address when sent :from" do
      @mailout = Mailout.new
      @sender = Sender.new(:from => '123@test.lindsaar.net')
      @mailout.sender = @sender
      @mailout.from.should == @sender.from
    end

    it "should give it's sender's reply_to address when sent :reply_to" do
      @mailout = Mailout.new
      @sender = Sender.new(:reply_to => '123@test.lindsaar.net')
      @mailout.sender = @sender
      @mailout.reply_to.should == @sender.reply_to
    end
  end

  describe "message relationship" do
    it "should give it's message's multipart setting when sent :multipart?" do
      @mailout = Mailout.new
      @message = Message.new(:multipart => true)
      @mailout.message = @message
      @mailout.should be_multipart
    end

    it "should give it's message's plain_part text when sent :plain_part" do
      @mailout = Mailout.new
      @message = Message.new(:plain_part => "This is plain text")
      @mailout.message = @message
      @mailout.plain_part.should == "This is plain text"
    end

    it "should give it's message's html_part text when sent :html_part" do
      @mailout = Mailout.new
      @message = Message.new(:html_part => "This is HTML")
      @mailout.message = @message
      @mailout.html_part.should == "This is HTML"
    end
  end

end
