desc 'Bootstraps the system'
task :bootstrap => :environment do
  if Organization.find(:first) || User.find(:first)
    STDERR.puts "\n================================================="
    STDERR.puts "You have already bootstrapped the system or have"
    STDERR.puts "user or org data entered in the database."
    STDERR.puts "\nCan only bootstrap a new installation."
    STDERR.puts "=================================================\n"
  else
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
end
