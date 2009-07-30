class MailoutsController < ApplicationController
  
  def index
    @mailouts = Mailout.find(:all)
  end
  
  def show
    @mailout = Mailout.find(params[:id])
  end
  
  def new
    @mailout = Mailout.new
    if params[:message_id]
      @mailout.message_id = params[:message_id]
      @mailout.title      = @mailout.message.title
    end
  end
  
  def create
    @mailout = Mailout.new(params[:mailout])
    if @mailout.next!
      render :action => :edit
    else
      render :action => :new
    end
  end
  
  def edit
    @mailout = Mailout.find(params[:id])
  end
  
  def update
    @mailout = Mailout.find(params[:id])
    @mailout.attributes = params[:mailout]
    @mailout.next!
    case @mailout.state
    when "confirmed"
      redirect_to mailouts_path
    else
      render :action => :edit
    end
  end
  
end
