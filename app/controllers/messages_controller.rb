class MessagesController < ApplicationController

  def index
    @messages = Message.find(:all)
  end
  
  def show
    @message = Message.find(params[:id])
  end
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.next!
      render :action => :edit
    else
      render :action => :new
    end
  end
  
  def edit
    @message = Message.find(params[:id])
  end
  
  def update
    @message = Message.find(params[:id])
    @message.attributes = params[:message]
    @message.next!
    case @message.state
    when "complete"
      redirect_to messages_path
    else
      render :action => :edit
    end
  end
  
end
