require File.dirname(__FILE__) + '/../spec_helper'

describe Mailer do
  it "should as the Mailout class for all the mailouts ready to be sent" do
    time = Time.now
    Time.stub!(:now).and_return(time)
    Mailout.should_receive(:ready_to_send).and_return([])
    Mailer.send!
  end
  
  it "should send a mailout" do
    mailout = Factory(:mailout, :title => "123")
    Mailout.should_receive(:ready_to_send).and_return([mailout])
    Mailer.should_receive(:send_mailout).once.with(mailout)
    Mailer.send!
  end
  
  it "should get a list of people for the mailer to send the mailout to" do
    mailout = Factory(:mailout, :title => "123")
    mailout.should_receive(:subscribers).and_return([])
    Mailout.should_receive(:ready_to_send).and_return([mailout])
    Mailer.send!
  end
  
end
