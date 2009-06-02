class Attachment < ActiveRecord::Base
  
  require 'mime/types'
  
  belongs_to :message
  
  before_validation :guess_content_type
  
  def guess_content_type
    self.content_type = MIME::Types.type_for(filename).first.content_type
  end
  
  def relative_path
    [directory, filename].join("/")
  end
  
end
