Given /^there is a organization I added in the system called "([^\"]*)"$/ do |name|
  Factory(:organization, :name => name)
end

Then /^no organizations in the system$/ do
  Organization.destroy_all
end

Then /^there should be (\d+) organizations in the system$/ do |number|
  Organization.count.should == number.to_i
end