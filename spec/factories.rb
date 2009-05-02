Factory.define :user do |f|
  f.login 'bob'
  f.password 'PassWord'
  f.password_confirmation 'PassWord'
  f.email 'bob@someplace.com'
end
