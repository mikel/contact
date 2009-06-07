class Recipient < ActiveRecord::Base
  
  belongs_to :organization

  has_many :subscriptions
  has_many :groups, :through => :subscriptions
  
  has_many :addressees
  has_many :messages, :through => :addressees
  
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
  
  def add_group_id=(group_id)
    return if group_id.blank?
    self.groups << Group.find(group_id)
  end

  def add_group_id
    nil
  end
end
