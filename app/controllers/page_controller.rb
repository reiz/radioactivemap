class PageController < ApplicationController

  def contact
  end

  def about
  end

  def home
    if signed_in?
      @measurement = Measurement.new
      @measurement.msph = 1;
      @feed_items = current_user.feed.paginate(:page => params[:page])
      @user = current_user
      @followers = @user.followers.paginate(:page => 1)
      @following = @user.following.paginate(:page => 1)
    else
      @forShow = Measurement.all
    end

    respond_to do |format|
      format.html
      format.json{
        render :json => @feed_items.to_json
      }
    end
  end

  def myfeed
    user = User.authenticate(params[:email],
                             params[:password])
    if !user.nil?
      @feed_items = user.feed
    end

    resp = feed_with_callback(params[:jsoncallback])
#    resp = feed_with_callback('jsonCalli')

    respond_to do |format|
      format.json{
        render :json => resp
      }
    end
  end

  def terms
  end

  def signin
  end

  def signup
  end

  private

  def feed_with_callback(callback)
    json = callback + '('
    json += @feed_items.to_json
    json += ')'
    json
  end

end