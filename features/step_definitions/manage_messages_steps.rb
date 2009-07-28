When /^there is a message called "([^\"]*)" in the system with "([^\"]*)" as a recipient$/ do |title, recipient|
  message = Factory(:message, :title => title, :aasm_state => 'select_recipients', :user => User.first)
  given, family = recipient.split(" ", 2)
  recipient = Factory(:recipient, :given_name => given, :family_name => family, :organization => User.first.organization)
  message.save!
  message.recipients << recipient
end

When /^there is a message called "([^\"]*)" in the system with "([^\"]*)" as a group$/ do |title, group|
  message = Factory(:message, :title => title, :aasm_state => 'select_recipients', :user => User.first)
  group = Factory(:group, :name => group, :user => User.find(:first))
  message.save!
  message.groups << group
end

When /^there is a message called "([^\"]*)" in the system with "([^\"]*)" as a group that has been scheduled$/ do |title, group|
  message = Factory(:message, :title => title, :aasm_state => "confirm_mailout", :user => User.first,
                    :date_scheduled => 1.day.from_now)
  group = Factory(:group, :name => group, :user => User.find(:first))
  message.save!
  message.groups << group
end

When /^there is a message called "([^\"]*)" in the system$/ do |title|
  message = Factory(:message, :title => title, :aasm_state => 'select_recipients', :user => User.first)
  message.save!
end

Then /^the message entitled "([^\"]*)" should have one (.*)$/ do |title, collection|
  Message.find(:first, :conditions => {:title => title}).send(collection.pluralize).count.should == 1
end

Then /^the message called "([^\"]*)" should have no (.*)$/ do |title, collection|
  Message.find(:first, :conditions => {:title => title}).send(collection).count.should == 0
end

Then /^the message called "([^\"]*)" should have a scheduled time of "([^\"]*)"$/ do |title, time|
  @message = Message.find(:first, :conditions => {:title => title})
  if time == 'now'
    # Don't want to stub Time, so just see if it is within 10 seconds of now
    (@message.date_scheduled.to_i - Time.now.to_i).abs.should < 10
  else
    @message.date_scheduled.should == DateTime.parse(time)
  end
end
