class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :memberships
  has_many :roles, :through => :memberships
  
  # Makes this user a member of the administrator group
  def add_role!(role_name)
    role = Role.find_by_name!(role_name.to_s)
    self.roles << role unless self.roles.include?(role)
  end
  
  def remove_role!(role_name)
    role = Role.find_by_name!(role_name.to_s)
    self.roles.delete(role) if self.roles.include?(role)
  end

  # Returns true if this user is an administrator
  def member_of?(role_name)
    !!self.roles.find_by_name(role_name.to_s)
  end
  
  def admin=(bool)
    if boolianize(bool)
      add_role!(:admin)
    else
      remove_role!(:admin)
    end
  end
  
  def admin
    member_of?(:admin)
  end
  
  def last_admin?
    !User.find(:first, :conditions => ["users.id != ? AND roles.name = 'admin'", self.id],
                       :joins => [:roles, :memberships])
  end

  private
  
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
