class Delivery < ActiveRecord::Base
  
  require 'cgi'
  
  belongs_to :recipient
  belongs_to :user
  belongs_to :mailout
  
  def unique_path
    path = Crypto::AES256.encrypt("#{recipient_id}|#{user_id}|#{mailout_id}|#{Time.now.to_i}")
    CGI.escape(path)
  end
  
  def Delivery.for(unique_path)
    path = CGI.unescape(unique_path)
    string = Crypto::AES256.decrypt(path)
    recipient_id, user_id, mailout_id, time = string.split("|")
    Delivery.find(:first, :conditions => {:recipient_id => recipient_id,
                                          :user_id      => user_id,
                                          :mailout_id   => mailout_id})
  end
  
end
