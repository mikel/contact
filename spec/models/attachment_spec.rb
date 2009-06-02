require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attachment do

  describe "associations" do
    it "should belong to a message" do
      @attachment = Attachment.new
      @message = Message.new
      @attachment.message = @message
      @attachment.message.should == @message
    end
  end

  describe "content types" do
    it "should try and guess the content type before validation" do
      @attachment = Attachment.new
      @attachment.filename = 'image.png'
      @attachment.valid?
      @attachment.content_type.should == "image/png"
    end
  end

  describe "giving it's relative path" do
    it "should give a relative path" do
      @attachment = Attachment.new
      @attachment.filename = 'image.png'
      @attachment.directory = 'images'
      @attachment.relative_path.should == 'images/image.png'
    end
  end

end
