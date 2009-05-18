
desc 'Bootstraps the system'
task :bootstrap => :environment do
  user = User.new(:password => 'mailer',
                  :password_confirmation => 'mailer',
                  :given_name => 'Default',
                  :family_name => 'Admin',
                  :email => 'admin@nowaythisisadomainname.org.au')
  user.login = 'admin'
  Role.create!(:name => 'admin')
  Membership.create!(:user_id => 1, :role_id => 1)
  user.save!
  user.add_role!('admin')
end
