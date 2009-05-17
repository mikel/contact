Then /^I should see 1 user account$/ do
  pending
end

Given /^a user with username "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  Factory(:user, :login => login, :password => password)
end

