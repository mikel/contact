Given /^there is an email template I made in the system with title "([^\"]*)"$/ do |title|
  user = User.find(:first)
  template = Factory(:email_template, :title => title)
  template.user = user
  template.save!
end
