Factory.define :user do |u|
  u.login "Bob"
  u.password "PassWord"
  u.password_confirmation { |a| a.password }
  u.email { |a| "#{a.login}@someplace.com" }
end

Factory.define :admin_user, :parent => :user do |a|

end