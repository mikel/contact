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
      @message.source = "edit"
      @message.next_step.should == 'plain_text'
    end

    it "should say what it's next step is select template if it's source is template" do
      @message = Message.new
      @message.source = "template"
      @message.next_step.should == 'select_template'
    end

    it "should say what it's next step is select file if it's source is upload" do
      @message = Message.new
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
      @message.email_template_id = @email_template.id
      @message.state = 'template_selected'
      @message.next_step.should == 'edit_content'
      @message.html_part.should == @email_template.html_part
      @message.plain_part.should == @email_template.plain_part
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

  end

end
