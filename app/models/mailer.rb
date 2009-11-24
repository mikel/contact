class Mailer < ActionMailer::Base

  def self.send!
    scheduled_mailouts.each do |mailout|
      send_mailout(mailout)
    end
  end
  
  private
  
  def self.send_mailout(mailout)
    mailout.subscribers.each do |recipient|
      deliver_mailout(recipient, mailout)
      Delivery.create!(:recipient_id => recipient.id, 
                       :mailout_id   => mailout.id,
                       :sent_at      => Time.now,
                       :user_id      => mailout.user_id)
    end
    mailout.next!
  end
  
  def mailout(recipient, mailout)
    recipients      recipient.email
    subject         mailout.title
    from            mailout.from
    reply_to        mailout.reply_to
    if mailout.multipart?
      content_type    "multipart/alternative" 
      part "text/html" do |p| 
        p.body = render_message("mailout_html", :message => mailout.html_part) 
      end 
      part "text/plain" do |p| 
        p.body = render_message("mailout_plain", :message => mailout.plain_part) 
      end 
    else
      body = mailout.plain_part
    end
  end
  
  def self.scheduled_mailouts
    Mailout.ready_to_send
  end

end
