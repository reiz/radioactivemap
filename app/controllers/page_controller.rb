class PageController < ApplicationController

  def contact
  end

  def about
  end

  def home
    @forShow = Measurement.all
    @test = "test"
    if signed_in?
      @measurement = Measurement.new
      @measurement.msph = 1;
      @feed_items = current_user.feed.paginate(:page => params[:page])
      @user = current_user
      @followers = @user.followers.paginate(:page => 1)
      @following = @user.following.paginate(:page => 1)
    end

  end

  def terms
  end

  def signin
  end

  def signup
  end

end
