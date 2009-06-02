class MessagesController < ApplicationController
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    @message.save
    render :action => :edit
  end
  
  def update
    @message = Message.find(params[:id])
    @message.attributes = params[:message]
    case @message.next_step
    when "finished"
      
      
    else
      render :action => :edit
    end
  end
  
end
