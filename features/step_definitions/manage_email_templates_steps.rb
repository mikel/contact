Given /^there is an email template I made in the system with title "([^\"]*)"$/ do |title|
  user = User.find(:first)
  template = Factory(:email_template, :title => title)
  template.user = user
  template.save!
end

Given /^the email template entitled "([^\"]*)" has an image attached called "([^\"]*)"$/ do |title, image_name|
  template = EmailTemplate.find_by_title(title)
  attachment = Factory(:attachment, :data => File.read(File.join(RAILS_ROOT, 'spec', 'resources', 'rails.png')))
end