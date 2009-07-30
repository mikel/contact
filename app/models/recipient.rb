class Recipient < ActiveRecord::Base
  
  # Use state machine for state transitions
  include AASM
  aasm_column :aasm_state
  aasm_initial_state :ok
  
  aasm_state :ok
  aasm_state :black_listed
  
  belongs_to :organization

  has_many :subscriptions
  has_many :groups, :through => :subscriptions
  
  has_many :addressees
  has_many :mailouts, :through => :addressees
  
  validates_presence_of :organization_id
  validates_associated :organization
  
  def name
    "#{given_name} #{family_name}"
  end
  
  aasm_event :black_list do
    transitions :to => :black_listed, :from => [:ok]
  end
  
  def add_group_id=(group_id)
    return if group_id.blank?
    self.groups << Group.find(group_id)
  end

  def add_group_id
    nil
  end
  
  def state
    aasm_state
  end
end
