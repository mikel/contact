Given /^I am logged in$/ do
  user = login_user
  visit path_to("the new user sessions page")
  fill_in("Login", :with => user.login) 
  fill_in("password", :with => user.password) 
  click_button("Login")
end

Given /^I am logged out$/ do
  visit path_to("the logout page")
end

Given /^I am logged in as an admin$/ do
  user = login_user(:make_administrator)
  visit path_to("the new user sessions page")
  fill_in("Login", :with => user.login) 
  fill_in("password", :with => user.password) 
  click_button("Login")
end

Given /^"([^\"]*)" is a.? "([^\"]*)"$/ do |user, role|
  User.find_by_login(user).send("#{role}=", true)
end

Given /^there is an admin in the system$/ do
  user = Factory(:user, :login => 'mr_admin')
  role = Factory(:admin_role)
  user.admin = true
end

Given /^there is a file called "([^\"]*)"$/ do |filename|
  make_file(filename).should be_true
end

Then /^the "([^\"]*)" with "([^\"]*)" of "([^\"]*)" should have a "([^\"]*)" with "([^\"]*)" of "([^\"]*)"$/ do |klass_1, attribute_1, value_1, klass_2, attribute_2, value_2|
  parent = klass_1.capitalize.constantize.find(:first, :conditions => {attribute_1 => value_1})
  child = klass_2.capitalize.constantize.find(:first, :conditions => {attribute_2 => value_2})
  parent.send(klass_2.pluralize).should include(child)
end
