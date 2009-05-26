class RecipientsController < ApplicationController
  
  before_filter :require_user
  
  def index
    @recipients = current_user.recipients
  end
  
  def new
    @recipient = Recipient.new(:organization => current_user.organization)
  end
  
  def create
    @recipient = Recipient.new(params[:recipient])
    @recipient.organization = current_user.organization
    if @recipient.save
      flash[:notice] = "Recipient created"
      redirect_to recipients_path
    else
      render :action => :new
    end
  end
  
  def edit
    @recipient = current_user.recipients.find(params[:id])
  end
  
  def update
    @recipient = current_user.recipients.find(params[:id])
    @recipient.attributes = params[:recipient]
    @recipient.organization = current_user.organization
    if @recipient.save
      flash[:notice] = "Recipient updated"
      redirect_to recipients_path
    else
      render :action => :new
    end
  end

  def black_list
    @recipient = current_user.recipients.find(params[:id])
    @recipient.black_list!
    flash[:notice] = "Recipient successfully black listed"
    redirect_to recipients_path
  end

  def destroy
    @recipient = current_user.recipients.find(params[:id])
    @recipient.delete
    flash[:notice] = "Recipient successfully deleted"
    redirect_to recipients_path
  end
  
end
