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
    update_user(@user, params[:user])
    if @user.save
      flash[:notice] = "User #{@user.login} successfully created"
      redirect_to users_path
    else
      render :action => :new
    end
  end
  
  def edit
    if current_user.admin
      @user = User.find(params[:id])
    else
      @user = User.find(current_user.id)
    end
  end
  
  def update
    if current_user.admin
      @user = User.find(params[:id])
      update_user(@user, params[:user])
    else
      @user = User.find(current_user.id)
      @user.attributes = params[:user]
    end
    if @user.save
      if current_user.admin
        flash[:notice] = "Update Successful"
        redirect_to users_path
      else
        flash[:notice] = "Successfully updated profile"
        redirect_to root_path
      end
    else
      render :action => :edit
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

  private
  
  def update_user(user, params_hash)
    user.attributes = params[:user]
    user.login = params[:user][:login]
    user.admin = params[:user][:admin]
  end
  
end
