class OrganizationsController < ApplicationController
  
  before_filter :require_user
  before_filter :admin_only
  
  def index
    @organizations = Organization.find(:all)
  end
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      flash[:notice] = "Organization successfully created"
      redirect_to organizations_path
    else
      render :action => :new
    end
  end
  
  def edit
    @organization = Organization.find(params[:id])
  end
  
  def update
    @organization = Organization.find(params[:id])
    @organization.attributes = params[:organization]
    if @organization.save
      flash[:notice] = "Organization successfully updated"
      redirect_to organizations_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @organization = Organization.find(params[:id])
    @organization.delete
    flash[:notice] = "Organization successfully deleted"
    redirect_to organizations_path
  end
  
end
