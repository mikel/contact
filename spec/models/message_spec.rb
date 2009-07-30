require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
    
  def valid_attributes
    { :title => "New Message" }
  end
  
  def new_message(args = {})
    Message.new(valid_attributes.merge!(args))
  end

  describe "validations" do

    it "should be invalid without a title" do
      @message = new_message
      @message.should be_valid
      @message.title = nil
      @message.should_not be_valid
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

    it "should have many mailouts" do
      @message = Message.new
      @mailout = Mailout.new
      @message.mailouts << @mailout
      @message.mailouts.should include(@mailout)
    end

  end
  
  describe "view helper methods" do
    it "should change the state into a nice human value for a single word" do
      @message = new_message
      @message.aasm_state = 'new'
      @message.nice_state.should == "New"
    end

    it "should change the state into a nice human value for multiple words" do
      @message = new_message
      @message.aasm_state = 'edit_content'
      @message.nice_state.should == "Edit content"
    end
    
    it "should change the type into a nice human value for non multipart" do
      @message = new_message
      @message.multipart = false
      @message.nice_type.should == "Plain Text Only"
    end
    
    it "should change the type into a nice human value for multipart" do
      @message = new_message
      @message.multipart = true
      @message.nice_type.should == "Multipart Email"
    end

    it "should change the source into a nice human value for multiple words" do
      @message = new_message
      @message.source = 'plain'
      @message.nice_source.should == "Directly Edited"
    end
    
    it "should change the source into a nice human value for plain text" do
      @message = new_message
      @message.source = 'html'
      @message.nice_source.should == "From HTML Files"
    end
    
    it "should change the source into a nice human value for html" do
      @message = new_message
      @message.source = 'template'
      @message.nice_source.should == "From Template"
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
  
  
    it "should set it's html_part and plain_part to that of the email template during the next transition if the state is 'select_template'" do
      @message = Message.new
      @email_template = Factory(:email_template)
      @message.title = "Test Email"
      @message.email_template_id = @email_template.id
      @message.aasm_state = 'select_template'
      @message.next!
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
      @message.aasm_state = 'select_template'
      @message.next!
      @message.attachments.count.should == 1
      @message.attachments.first.filename.should == 'rails.png'
    end
    
  end
  
  describe "state transitions using next!" do
    
    it "should be initially in the new state" do
      @message = new_message
      @message.save
      @message.state.should == "new"
    end
    
    it "should not transition from new without a source being defined" do
      @message = new_message(:aasm_state => "new")
      @message.next!.should be_false
    end

    it "should transition from new to edit_content if source is plain" do
      @message = new_message(:aasm_state => "new")
      @message.source = "plain"
      @message.next!
      @message.state.should == "edit_content"
    end

    it "should transition from new to select_html if source is html" do
      @message = new_message(:aasm_state => "new")
      @message.source = "html"
      @message.next!
      @message.state.should == "select_html"
    end

    it "should transition from new to select_template if source is template" do
      @message = new_message(:aasm_state => "new")
      @message.source = "template"
      @message.next!
      @message.state.should == "select_template"
    end

    it "should transition from select_html to edit_content" do
      @message = new_message(:aasm_state => "select_html")
      @message.next!
      @message.state.should == "edit_content"
    end

    it "should transition from select_template to edit_content" do
      @message = new_message(:aasm_state => "select_template")
      @message.next!
      @message.state.should == "edit_content"
    end

    it "should transition from edit_content to select_recipients" do
      @message = new_message(:aasm_state => "edit_content", :source => 'plain')
      @message.next!
      @message.state.should == "complete"
    end

  end
  
  describe "state transitions using previous!" do
    
    it "should transition to edit_content from select_recipients" do
      @message = new_message(:aasm_state => "complete")
      @message.source = 'plain'
      @message.previous!
      @message.state.should == "edit_content"
    end
    
    it "should transition to select_html from edit_content if the source is html" do
      @message = new_message(:aasm_state => "edit_content")
      @message.source = 'html'
      @message.previous!
      @message.state.should == "select_html"
    end
    
    it "should transition to select_template from edit_content if the source is template" do
      @message = new_message(:aasm_state => "edit_content")
      @message.source = 'template'
      @message.previous!
      @message.state.should == "select_template"
    end
    
    it "should transition to new from edit_content if the source is plain" do
      @message = new_message(:aasm_state => "edit_content")
      @message.source = 'plain'
      @message.previous!
      @message.state.should == "new"
    end
    
    it "should transition to new from select_html" do
      @message = new_message(:aasm_state => "select_html")
      @message.previous!
      @message.state.should == "new"
    end
    
    it "should transition to new from select_template" do
      @message = new_message(:aasm_state => "select_template")
      @message.previous!
      @message.state.should == "new"
    end
    
  end

end
