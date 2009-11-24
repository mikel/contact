Given /^there are no mailouts to send$/ do
  Mailout.destroy_all
end

Given /^there are no deliveries in the system$/ do
  Delivery.destroy_all
end

When /^I tell the system to send$/ do
  Mailer.send!
end

Then /^no deliveries should be made$/ do
  Delivery.count.should == 0
end

Given /^there is one mailout called "([^\"]*)" to be sent immediately$/ do |title|
  mailout = Factory(:mailout, :title => title, :date_scheduled => 1.day.ago, :aasm_state => 'confirmed')
end

Given /^the mailout "([^\"]*)" has the recipient "([^\"]*)"$/ do |title, name|
  mailout = Mailout.find_by_title(title)
  given, family = name.split(' ')
  recipient = Recipient.find(:first, :conditions => {:given_name => given, :family_name => family})
  mailout.recipients << recipient
end

Then /^there should be (\d+) delivery$/ do |number|
  number = number.to_i
  ActionMailer::Base.deliveries.length.should == number
  Delivery.count.should == number
end

Then /^there should be (\d+) deliveries$/ do |number|
  number = number.to_i
  ActionMailer::Base.deliveries.length.should == number
  Delivery.count.should == number
end

Then /^the recipient "([^\"]*)" should have been delivered one email$/ do |name|
  given_name, family_name = name.split(" ")
  recipient = Recipient.find(:first, :conditions => {:given_name => given_name, :family_name => family_name})
  recipient.deliveries.count.should == 1
end

When /^I reset the mailout "([^\"]*)" to send again and send it$/ do |title|
  mailout = Mailout.find_by_title(title)
  mailout.previous!
  Mailer.send!
end

Given /^there is a group called "([^\"]*)"$/ do |name|
  Factory(:group, :name => name, :user => User.find(:first))
end

Given /^"([^\"]*)" belongs to "([^\"]*)"$/ do |recipient_name, group_name|
  given, family = recipient_name.split(" ")
  recipient = Recipient.find(:first, :conditions => {:given_name => given, :family_name => family})
  group = Group.find(:first, :conditions => {:name => group_name})
  group.recipients << recipient
  group.save!
end

Given /^the mailout "([^\"]*)" has the group "([^\"]*)"$/ do |mailout_name, group_name|
  mailout = Mailout.find(:first, :conditions => {:title => mailout_name})
  group = Group.find(:first, :conditions => {:name => group_name})
  mailout.groups << group
  mailout.save!
end

Given /^there is one mailout called "([^\"]*)" to be sent one day from now$/ do |title|
  mailout = Factory(:mailout, :title => title, :date_scheduled => 1.day.from_now, :aasm_state => 'confirmed')
end
