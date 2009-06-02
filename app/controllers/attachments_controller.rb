class AttachmentsController < ApplicationController
  
  def thumbnail
    attachment = Attachment.find(params[:id])
    send_data attachment.data, :type => attachment.content_type, :disposition => 'inline'
  end
  
end
