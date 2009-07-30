
When /^there is a message called "([^\"]*)" in the system$/ do |title|
  message = Factory(:message, :title => title, :aasm_state => 'select_recipients', :user => User.first)
  message.save!
end
