require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do

  describe "validations" do
    it "should be invalid without a title" do
      @message = Message.new
      @message.title = "Hello"
      @message.should be_valid
      @message.title = nil
      @message.should_not be_valid
    end
    
    it "should be invalid without a recipient if the state is at 'recipients_selected'" do
      @message = Message.new
      @message.title = "Hello"
      @message.state = 'recipients_selected'
      @message.should_not be_valid
    end

    it "should be valid if the state is at 'recipients_selected' and it has a recipient" do
      @message = Message.new
      @message.title = "Hello"
      @message.state = 'recipients_selected'
      @recipient = Factory(:recipient, :email => "mikel@me.com")
      @message.add_recipient = @recipient.email
      @message.should be_valid
    end

    it "should be valid if the state is at 'recipients_selected' and it has a group" do
      @message = Message.new
      @message.title = "Hello"
      @message.state = 'recipients_selected'
      @group = Factory(:group)
      @message.add_group_id = @group
      @message.should be_valid
    end
  end

  describe "associations" do
    
    it "should belong to a user" do
      @message = Message.new
      @User = User.new
      @message.user = @user
      @message.user.should == @user
    end
    
    it "should belong to an email template" do
      @message = Message.new
      @email_template = EmailTemplate.new
      @message.email_template = @email_template
      @message.email_template.should == @email_template
    end
    
    it "should have many attachments" do
      @message = Message.new
      @attachment = Attachment.new
      @message.attachments << @attachment
      @message.attachments.should include(@attachment)
    end
    
    it "should have many recipients through addressees" do
      @message = Message.new
      @recipient = Recipient.new
      @message.recipients << @recipient
      @message.recipients.should include(@recipient)
    end
    
    it "should have many groups through addressees" do
      @message = Message.new
      @group = Group.new
      @message.groups << @group
      @message.groups.should include(@group)
    end
    
    it "should have an organization via user" do
      @org = Factory(:organization)
      @user = Factory(:user, :organization => @org)
      @message = Message.new(:user => @user)
      @message.organization.should == @org
    end
  end
  
  describe "helper for adding a group individually" do
    it "should have the virtual attribute :add_group_id" do
      @message = Message.new
      @message.should respond_to(:add_group_id)
    end

    it "should have the virtual attribute :add_group_id=" do
      @message = Message.new
      @message.should respond_to(:add_group_id=)
    end
    
    it "should make an addressee off the group id" do
      @message = Message.new
      @message.id = 10
      @group = mock_model(Group, :valid? => true)
      Group.stub!(:find).and_return(@group)
      @message.add_group_id = 5
      @message.groups.should include(@group)
      
    end
  end

  describe "helper for setting the schedule" do
    it "should have a virtual attribute called 'schedule'" do
      @message = Message.new
      @message.should respond_to(:schedule)
      @message.should respond_to(:schedule=)
    end
    
    it "should rest the date_scheduled to now if schedule is set to 'now'" do
      @time = Time.now
      Time.stub!(:now).and_return(@time)
      @message = Message.new
      @message.schedule = 'now'
      @message.date_scheduled.should == @time
    end
  end

  describe "helper for adding a recipient individually" do
    it "should have the virtual attribute :add_recipient" do
      @message = Message.new
      @message.should respond_to(:add_recipient)
    end

    it "should have the virtual attribute :add_recipient=" do
      @message = Message.new
      @message.should respond_to(:add_recipient=)
    end
    
    it "should find the recipient of email address if given an email address" do
      @message = Message.new
      @message.id = 10
      Recipient.should_receive(:find).with(:first, :conditions => {:email => 'mikel@me.com'})
      Addressee.stub!(:create!)
      @message.add_recipient = 'mikel@me.com'
    end
    
    it "should find the recipient off given and family name if given a given and family name" do
      @message = Message.new
      @message.id = 10
      Recipient.should_receive(:find).with(:first, :conditions => {:given_name => 'Mikel', :family_name => "Lindsaar"})
      @message.add_recipient = 'Mikel Lindsaar'
    end

    it "should create the subscription with the found recipient id" do
      @message = Message.new
      @message.id = 10
      @recipient = mock_model(Recipient)
      Recipient.stub!(:find).and_return(@recipient)
      @message.add_recipient = 'Mikel Lindsaar'
      @message.recipients.should include(@recipient)
    end
    
    it "should not try adding an addressee if no recipient was found" do
      @message = Message.new
      @message.id = 10
      Recipient.stub!(:find).and_return(nil)
      doing { @message.add_recipient = 'Mikel Lindsaar' }.should_not raise_error
    end
    
    it "should not try to add a recipient if none was given" do
      @message = Message.new
      @message.id = 10
      doing { @message.add_recipient = '' }.should_not raise_error
    end
    
    it "should not try to add a group if none was given" do
      @message = Message.new
      @message.id = 10
      doing { @message.add_group_id = '' }.should_not raise_error
    end
    
    it "should add an error to base if no recipient was found" do
      @message = Message.new
      Recipient.stub!(:find).and_return(nil)
      @message.add_recipient = 'Mikel Lindsaar'
      @message.state = 'recipients_selected'
      @message.valid?
      @message.errors.full_messages.should include("No recipient found with 'Mikel Lindsaar'")
    end
    
    it "should say 'Please select at least one recipient' if there are no recipients or groups selected already and nothing is passed in" do
      @message = Message.new
      Recipient.stub!(:find).and_return(nil)
      @message.add_recipient = ''
      @message.state = 'recipients_selected'
      @message.valid?
      @message.errors.full_messages.should include("Please select at least one recipient")
    end
    
  end

  describe "file handling for source data" do
    it "should have an html_file_data virtual attribute" do
      @message = Message.new
      data = mock("File", :read => "abc")
      doing { @message.html_file_data = data }.should_not raise_error
    end

    it "should assign the a passed in file's contents given to html_file_data to the html_part" do
      @message = Message.new
      data = mock("File", :read => "<h1>abc</h1>")
      @message.html_file_data = data
      @message.html_part.should == "<h1>abc</h1>"
    end

    it "should assign the a passed in file's contents given to html_file_data to the plain_part without HTML tags" do
      @message = Message.new
      data = mock("File", :read => "<h1>abc</h1>")
      @message.html_file_data = data
      @message.plain_part.should == "abc"
    end
    
    it "should try to convert entities" do
      @message = Message.new
      data = mock("File", :read => "<h1>abc &amp; 123</h1>")
      @message.html_file_data = data
      @message.plain_part.should == "abc & 123"
    end
    
    it "should handle assigning nothing to the zip_file_data= attribute" do
      @message = Message.new
      doing { @message.zip_file_data = "" }.should_not raise_error 
    end
    
    it "should create an associated message if given a zip file with a single image in it" do
      @message = Factory(:message)
      filename = File.join(RAILS_ROOT, 'spec', 'resources', 'simple_email', 'images.zip')
      File.open(filename) do |file|
        file.stub!(:original_filename).and_return('images.zip')
        doing { @message.zip_file_data = file }.should change(Attachment, :count).by(1)
      end
    end
    
  end
  
  describe "step definitions" do
    
    it "should say it's next step is new if it's source is nil" do
      @message = Message.new
      @message.source = nil
      @message.next_step.should == 'new'
    end
    
    it "should say it's next step is direct_entry if it's source is edit" do
      @message = Message.new
      @message.state = 'new'
      @message.source = "edit"
      @message.next_step.should == 'edit_content'
    end

    it "should say what it's next step is select template if it's source is template" do
      @message = Message.new
      @message.state = 'new'
      @message.source = "template"
      @message.next_step.should == 'select_template'
    end

    it "should say what it's next step is select file if it's source is upload" do
      @message = Message.new
      @message.state = 'new'
      @message.source = "upload"
      @message.next_step.should == 'select_files'
    end

    it "should set return edit_content if the state is set to 'template_selected'" do
      @message = Message.new
      @email_template = Factory(:email_template)
      @message.email_template_id = @email_template.id
      @message.state = 'template_selected'
      @message.next_step.should == 'edit_content'
    end
    
    it "should set it's html_part and plain_part to that of the email template if the state is 'template_selected'" do
      @message = Message.new
      @email_template = Factory(:email_template)
      @message.title = "Test Email"
      @message.email_template_id = @email_template.id
      @message.state = 'template_selected'
      @message.save!
      @message.html_part.should == @email_template.html_part
      @message.plain_part.should == @email_template.plain_part
    end
    
    it "should copy the email template's attachments over" do
      @email_template = Factory(:email_template)
      data = File.read(File.join(RAILS_ROOT, 'spec', 'resources', 'rails.png'))
      attachment = Factory(:attachment,
                           :filename => 'rails.png',
                           :directory => 'image',
                           :data => data, 
                           :content_type => 'image/png',
                           :message_id => @email_template.id)
      @message = Message.new(:title => "New Email", :email_template => @email_template)
      @message.state = 'template_selected'
      @message.save
      @message.attachments.count.should == 1
      @message.attachments.first.filename.should == 'rails.png'
    end

    it "should return confirm if the state is set to date_scheduled" do
      @message = Message.new
      @message.state = 'date_scheduled'
      @message.next_step.should == 'confirm'
    end

    it "should set return edit_content if the state is set to 'file_uploaded'" do
      @message = Message.new
      @message.state = 'file_uploaded'
      @message.next_step.should == 'edit_content'
    end
    
    it "should set it's html_part and plain_part to that of the index.html and plain.txt files uploaded if the state is 'file_uploaded'" do
      @message = Message.new
      @message.state = 'file_uploaded'
      @message.next_step.should == 'edit_content'
    end

    it "should return add_recipients if it's state is content_edited" do
      @message = Message.new
      @message.state = 'content_edited'
      @message.next_step.should == 'select_recipients'
    end

  end

end
