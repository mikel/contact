class Subscription < ActiveRecord::Base
  
  belongs_to :group
  belongs_to :recipient
  
end
