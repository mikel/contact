class UsersController < ApplicationController
  
  before_filter :require_user
  before_filter :admin_only, :except => [:show, :update, :edit]
  
  def index
    @users = User.find(:all)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new
    @user.attributes = params[:user]
    if @user.save
      flash[:notice] = "User #{@user.login} successfully created"
      redirect_to users_path
    else
      render :action => :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    if @user.save
      flash[:notice] = "Update Successful"
      redirect_to users_path
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    unless @user.last_admin?
      @user.delete
      flash[:notice] = "Deleted user #{@user.login} successfully"
    else
      flash[:error] = "Can not delete the last administrator"
    end
    redirect_to users_path
  end
  
end
