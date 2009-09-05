class Subscription < ActiveRecord::Base
  
  belongs_to :group
  belongs_to :recipient
  
  def self.recipient_ids_for(group_ids)
    subscriptions = find(:all, :conditions => {:group_id => group_ids}, :select => 'recipient_id')
    subscriptions.map { |s| s.recipient_id }
  end
  
end
