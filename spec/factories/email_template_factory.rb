Factory.define :email_template do |t|
  t.title "Email title"
  t.html_part  "This is the html part of the email"
  t.plain_part "This is the plain part of the email"
end
