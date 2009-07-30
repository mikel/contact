class Addressee < ActiveRecord::Base
  
  belongs_to :group
  belongs_to :recipient
  belongs_to :mailout
  
end
