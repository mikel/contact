Factory.define :recipient do |r|
  r.given_name 'George'
  r.family_name 'Man'
  r.email 'george@email.com'
  r.association :organization, :name => 'Sydney'
end
