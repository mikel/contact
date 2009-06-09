Factory.define :user do |u|
  u.login "bsmith"
  u.given_name "Bob"
  u.family_name "Smith"
  u.password "PassWord"
  u.password_confirmation { |a| a.password }
  u.email { |a| "#{a.login}@someplace.com" }
  u.association :organization
end

Factory.define :admin_user, :parent => :user do |a|

end