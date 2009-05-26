class User < ActiveRecord::Base
  acts_as_authentic

  has_many :email_templates
  has_many :memberships
  has_many :recipients,   :through => :organization
  has_many :roles,        :through => :memberships

  belongs_to :organization
  
  attr_accessible :given_name, :family_name, :email,
                  :password, :password_confirmation,
                  :organization_id

  validate_on_update :check_last_admin?
  validates_associated :organization
  validates_presence_of :organization_id
  
  def check_last_admin?
    if @tried_to_remove_admin && last_admin?
      errors.add_to_base "Can not remove the last admin from the system."
    end
  end
  
  def admin=(bool)
    if boolianize(bool)
      @tried_to_remove_admin = false
      add_role!(:admin)
    else
      @tried_to_remove_admin = true
      remove_role!(:admin) unless last_admin?
    end
  end
  
  def admin
    member_of?(:admin)
  end
  
  def last_admin?
    @last_admin ||= !User.find(:first, 
                               :conditions => ["users.id != ? AND roles.name = 'admin'", self.id],
                               :joins => [:roles, :memberships])
  end

  private

  # Adds this role from the users memberships
  def add_role!(role_name)
    role = Role.find_by_name!(role_name.to_s)
    self.roles << role unless self.roles.include?(role)
  end
  
  # Removes this role from the users memberships
  def remove_role!(role_name)
    role = Role.find_by_name!(role_name.to_s)
    self.roles.delete(role) if self.roles.include?(role)
  end

  # Returns true if this user is a member of this role
  def member_of?(role_name)
    !!self.roles.find_by_name(role_name.to_s)
  end
  
  def boolianize(bool)
    case bool
    when "1"
      true
    when "0"
      false
    else
      bool
    end
  end
  
end
