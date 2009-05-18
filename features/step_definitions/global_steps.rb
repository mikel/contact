Given /^I am logged in$/ do
  user = login_user
  visit path_to("the new user sessions page")
  fill_in("Login", :with => user.login) 
  fill_in("password", :with => user.password) 
  click_button("Login")
end

Given /^I am logged in as an admin$/ do
  user = login_user(:make_administrator)
  visit path_to("the new user sessions page")
  fill_in("Login", :with => user.login) 
  fill_in("password", :with => user.password) 
  click_button("Login")
end

Given /^"([^\"]*)" is a.? "([^\"]*)"$/ do |user, role|
  User.find_by_login(user).add_role!(role)
end
