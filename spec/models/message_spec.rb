require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do

  describe "associations" do
    it "should belong to an email template" do
      @message = Message.new
      @email_template = EmailTemplate.new
      @message.email_template = @email_template
      @message.email_template.should == @email_template
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
      @message.next_step.should == 'edit_content'
    end

    it "should say what it's next step is select template if it's source is template" do
      @message = Message.new
      @message.source = "template"
      @message.next_step.should == 'select_template'
    end

    it "should say what it's next step is select file if it's source is upload" do
      @message = Message.new
      @message.source = "upload"
      @message.next_step.should == 'select_file'
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
      @message.html_part.should == 
      @message.plain_part.should == 
    end

  end

  describe "file handling" do
    it "should be able to reference a temporary filename" do
      @message = Message.new
      
      @message.file_data = "abc 123"
      @message.file_data.should == "abc 123"
    end
  end

end
