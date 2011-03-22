class PageController < ApplicationController
  
  def contact
  end
  
  def about
  end

  def home
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def signin
  end

  def signup
  end

end
