class Recipient < ActiveRecord::Base
  
  belongs_to :organization

  validates_presence_of :organization_id
  validates_associated :organization
  
  def name
    "#{given_name} #{family_name}"
  end
  
  def black_list!
    self.update_attribute(:state, 'blacklisted')
  end

  def black_list
    @black_list ||= (self.state == 'blacklisted')
  end
  
end
