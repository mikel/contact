Given /^a user with username "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  Factory(:user, :login => login, :password => password)
end

When /^I click the delete link for "([^\"]*)"$/ do |login|
  user = User.find_by_login(login)
  click_link("delete_#{user.id}")
end

Then /^there should be (\d+) administrator.? in the system$/ do |number|
  Role.find_by_name('admin').users.count.should == number.to_i
end
