class Delivery < ActiveRecord::Base
  
  belongs_to :recipient
  belongs_to :user
  belongs_to :mailout
  
end
