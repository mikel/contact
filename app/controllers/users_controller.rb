class UsersController < ApplicationController
  
  before_filter :require_user
  before_filter :admin_only, :except => [:show, :update, :edit]
  
  def index
    @users = User.find(:all)
  end
  
end
