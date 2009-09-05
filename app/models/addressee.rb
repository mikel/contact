# The Addressee class is an explicit join table between Mailout, Group & Address
# 
# This way a mailout can have one or more groups and one or more recipients,
#
# When a group is added to a mailout
class Addressee < ActiveRecord::Base
  
  belongs_to :group
  belongs_to :recipient
  belongs_to :mailout
  
end
