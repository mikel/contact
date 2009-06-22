class MessagesController < ApplicationController

  def index
    @messages = Message.find(:all)
  end
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    @message.save
    render :action => :edit
  end
  
  def edit
    @message = Message.find(params[:id])
  end
  
  def update
    @message = Message.find(params[:id])
    @message.attributes = params[:message]
    @message.save
    case @message.next_step
    when "ready_to_send"
      redirect_to messages_path
    else
      render :action => :edit
    end
  end
  
end
