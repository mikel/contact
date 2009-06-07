Given /^there is a recipient I added in the system called "([^\"]*)"$/ do |name|
  org = Organization.find(:first)
  given, family = name.split
  Factory(:recipient, :given_name => given, :family_name => family, :organization => org)
end

Given /^no recipients in the system$/ do
  Recipient.destroy_all
end

Then /^there should be (\d+) recipients? in the system$/ do |number|
  Recipient.count.should == number.to_i
end

Then /^"([^\"]*)" should be black listed$/ do |name|
  given, family = name.split
  recipient = Recipient.find_by_given_name_and_family_name(given, family)
  recipient.black_list.should be_true
end

