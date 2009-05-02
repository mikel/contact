Given /^there is a user with username "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  Factory(:user, :login => login, :password => password, :password_confirmation => password)
end
