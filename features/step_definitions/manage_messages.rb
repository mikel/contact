When /^there is a message called "([^\"]*)" in the system with "([^\"]*)" as a recipient$/ do |title, recipient|
  message = Factory(:message, :title => title, :state => 'content_edited')
  given, family = recipient.split(" ", 2)
  recipient = Factory(:recipient, :given_name => given, :family_name => family)
  message.save!
  message.recipients << recipient
end

When /^there is a message called "([^\"]*)" in the system with "([^\"]*)" as a group$/ do |title, group|
  message = Factory(:message, :title => title, :state => 'content_edited')
  group = Factory(:group, :name => group, :user => User.find(:first))
  message.save!
  message.groups << group
end

When /^there is a message called "([^\"]*)" in the system$/ do |title|
  message = Factory(:message, :title => title, :state => 'content_edited')
  message.save!
end

Then /^the message entitled "([^\"]*)" should have one recipient/ do |title|
  Message.find_by_title(title).recipients.count.should == 1
end

Then /^the message entitled "([^\"]*)" should have one group/ do |title|
  Message.find_by_title(title).groups.count.should == 1
end

Then /^the message called "([^\"]*)" should have no recipients$/ do |title|
  Message.find_by_title(title).recipients.count.should == 0
end

Then /^the message called "([^\"]*)" should have no groups$/ do |title|
  Group.find_by_title(title).groups.count.should == 0
end