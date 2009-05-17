class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :memberships
  has_many :roles, :through => :memberships
  
  # Makes this user a member of the administrator group
  def add_role!(role_name)
    role = Role.find_by_name!(role_name.to_s)
    self.roles << role
  end

  # Returns true if this user is an administrator
  def member_of?(role_name)
    !!self.roles.find_by_name(role_name.to_s)
  end
  
end
