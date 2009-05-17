Factory.define :role do |u|
  u.name 'role'
end

Factory.define :admin_role, :class => :role do |u|
  u.name 'admin'
end


