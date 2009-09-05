# A Group is a collection of recipients (through the subscriptions class)
# this is a many to many association, additionally it has many mailouts,
# that is, mailouts that have been sent to this group, through a many to many
# association via addressee.
class Group < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :subscriptions
  has_many :recipients, :through => :subscriptions
  
  has_many :addressees
  has_many :mailouts,   :through => :addressees
  
end
