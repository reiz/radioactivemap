class PageController < ApplicationController

  def contact
  end

  def about
  end

  def home
    if signed_in?
      @measurement = Measurement.new if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page])
      @user = current_user
      @followers = @user.followers.paginate(:page => 1)
      @following = @user.following.paginate(:page => 1)
    end
  end

  def signin
  end

  def signup
  end

end
