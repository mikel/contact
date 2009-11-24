Then /^the delivery body should have "([^\"]*)"$/ do |text|
  ActionMailer::Base.deliveries.first.to_s.should =~ /#{text}/m
  
end

Then /^the delivery body should have a url to view the email especially for "([^\"]*)"$/ do |name|
  pending
end

