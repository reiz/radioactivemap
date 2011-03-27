class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only   => [:edit, :update]
  before_filter :admin_user,   :only   => :destroy

  def signup
    redirect_to :action => "new"
  end

  def new
    @user = User.new
    @title = "sign up"
  end

  def create 
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Radioactive Map"
      redirect_to @user
    else 
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @user = User.find_by_username(params[:id])
    @title = "Edit your Profile"
  end

  def update
    p params[:id]
    @user = User.find_by_username(params[:id])
    p @user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render "edit"
    end
  end

  def show
    @user = User.find_by_username(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  end

  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find_by_username(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find_by_username(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find_by_username(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end