class Group < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :subscriptions
  has_many :recipients, :through => :subscriptions
  
  has_many :addressees
  has_many :mailouts,   :through => :addressees
  
end
