Factory.define :message do |m|
  m.title "Hello World"
  m.source "plain"
  m.multipart false
  m.user { User.find(:first) }
  m.html_part "<h1>Hello World</h1>"
  m.plain_part "Hello World"
end

Factory.define :multipart_message, :parent => :message do |m|
  m.multipart true
  m.association :user
end

