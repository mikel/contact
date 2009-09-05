class Sender < ActiveRecord::Base
  
  belongs_to :organization
  has_many :mailouts

end
