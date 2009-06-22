
desc 'Bootstraps the system'
task :bootstrap => :environment do
  org = Organization.create!(:name => "Default")
  user = User.new(:password => 'contact',
                  :password_confirmation => 'contact',
                  :given_name => 'Default',
                  :family_name => 'Admin',
                  :email => 'admin@nowaythisisadomainname.org.au')
  user.organization = org
  user.login = 'admin'
  Role.create!(:name => 'admin')
  Membership.create!(:user_id => 1, :role_id => 1)
  user.admin = true
  user.save!
end
