class EmailTemplatesController < ApplicationController
  
  before_filter :require_user
  
  def index
    @email_templates = current_user.email_templates
  end
  
  def new
    @email_template = EmailTemplate.new(:user => current_user)
  end
  
  def edit
    @email_template = current_user.email_templates.find(params[:id])
  end
  
  def update
    @email_template = current_user.email_templates.find(params[:id])
    @email_template.attributes = params[:email_template]
    if @email_template.save
      redirect_to email_templates_path
    else
      render :action => :edit
    end
  end
  
  def create
    @email_template = EmailTemplate.new(params[:email_template])
    @email_template.user = current_user
    if @email_template.save
      redirect_to email_templates_path
    else
      render :action => :new
    end
  end
  
  def destroy
    @email_template = current_user.email_templates.find(params[:id])
    @email_template.destroy
    redirect_to email_templates_path
  end
  
end
