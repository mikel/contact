class MessagesController < ApplicationController
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    
    case @message.next_step
    when "finished"
      
    else
      render :action => :new
    end
  end
  
end
