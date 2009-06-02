Factory.define :attachment do |a|
  a.association :message, :factory => :multipart_message
  a.data File.read(File.join(RAILS_ROOT, 'spec', 'resources', 'rails.png'))
end
