Given /^there is one plain text mailout called "([^\"]*)" to be sent immediately$/ do |title|
  message = Factory(:message, :title => title, :source => 'plain', :plain_part => "This is a plain text email")
  Factory(:mailout, :message => message, :title => title, :date_scheduled => 1.day.ago, :aasm_state => 'confirmed')
end

When /^I go and visit the url for the "([^\"]*)" email for "([^\"]*)"$/ do |title, name|
  pending
end

Then /^the system should record that "([^\"]*)" read the email$/ do |name|
  pending
end

Given /^there is one multipart mailout called "([^\"]*)" to be sent immediately$/ do |title|
  message = Factory(:message, :title => title, :source => 'html', :multipart => true, :html_part => "<h1>This is a html part</h1>", :plain_part => "This is a plain text email")
  Factory(:mailout, :message => message, :title => title, :date_scheduled => 1.day.ago, :aasm_state => 'confirmed')
end
