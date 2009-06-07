Given /^there is a group in the system called "([^\"]*)"$/ do |name|
  Factory(:group, :name => name, :user => User.first)
end