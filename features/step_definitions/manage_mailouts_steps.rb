Given /^there is a mailout called "([^\"]*)" in the system$/ do |title|
  mailout = Factory(:mailout, :title => title, :user => User.first)
  mailout.save!
end

Given /^there is a mailout in the system called "([^\"]*)" with "([^\"]*)" as it's message$/ do |title, msg_title|
  message = Message.find_by_title(msg_title)
  mailout = Factory(:mailout, :title => title, :aasm_state => 'confirmed', :user => User.first, :message => message)
  message.save!
end

Given /^the mailout "([^\"]*)" is in the "([^\"]*)" state$/ do |title, state|
  mailout = Mailout.find(:first, :conditions => {:title => title})
  mailout.update_attribute(:aasm_state, state)
end

Given /^the mailout "([^\"]*)" has a recipient called "([^\"]*)"$/ do |title, recipient|
  mailout = Mailout.find_by_title(title)
  given, family = recipient.split(" ", 2)
  recipient = Factory(:recipient, :given_name => given, :family_name => family, :organization => User.first.organization)
  mailout.save!
  mailout.recipients << recipient
end

Given /^the mailout "([^\"]*)" has a group called "([^\"]*)"$/ do |title, group|
  mailout = Mailout.find_by_title(title)
  group = Factory(:group, :name => group, :user => User.find(:first))
  mailout.save!
  mailout.groups << group
end

Given /^there is a mailout called "([^\"]*)" in the system with a group called "([^\"]*)"$/ do |title, group|
  mailout = Factory(:mailout, :title => title, :user => User.first)
  group = Factory(:group, :name => group, :user => User.find(:first))
  mailout.save!
  mailout.groups << group
end

Given /^there is a mailout "([^\"]*)" with group "([^\"]*)" that has been scheduled$/ do |title, group|
  mailout = Factory(:mailout, :title => title, :aasm_state => "confirm_mailout",
                    :user => User.first, :date_scheduled => 1.day.from_now,
                    :message => Factory(:message))
  group = Factory(:group, :name => group, :user => User.find(:first))
  mailout.save!
  mailout.groups << group
end

Given /^there is a mailout "([^\"]*)" with message "([^\"]*)" and group "([^\"]*)" that has been scheduled$/ do |title, msg_title, group|
  message = Message.find_by_title(msg_title)
  mailout = Factory(:mailout, :title => title, :aasm_state => "confirm_mailout",
                    :user => User.first, :date_scheduled => 1.day.from_now,
                    :message => message)
  group = Factory(:group, :name => group, :user => User.find(:first))
  mailout.save!
  mailout.groups << group
end

Then /^the mailout called "([^\"]*)" should have a scheduled time of "([^\"]*)"$/ do |title, time|
  @mailout = Mailout.find(:first, :conditions => {:title => title})
  if time == 'now'
    # Don't want to stub Time, so just see if it is within 10 seconds of now
    (@mailout.date_scheduled.to_i - Time.now.to_i).abs.should < 10
  else
    @mailout.date_scheduled.should == DateTime.parse(time)
  end
end

Then /^the mailout entitled "([^\"]*)" should have one (.*)$/ do |title, collection|
  Mailout.find(:first, :conditions => {:title => title}).send(collection.pluralize).count.should == 1
end

Then /^the mailout called "([^\"]*)" should have no (.*)$/ do |title, collection|
  Mailout.find(:first, :conditions => {:title => title}).send(collection).count.should == 0
end

Then /^the mailout called "([^\"]*)" should be in the "([^\"]*)" state$/ do |title, state|
  Mailout.find(:first, :conditions => {:title => title}).state.should == state
end
