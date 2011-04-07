class SessionsController < ApplicationController

  @@fb_app_id = '216988828315277'
  @@fb_app_secret = 'fa38f03c9206cfe4888d713fa0dff65e'

#  @@radio_server = 'http://rob.wildgigs.com'
  @@ram_server = 'http://radioactive-map.com'

  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render "new"
    else
      sign_in user
      redirect_back_or "/home"
    end
  end

  def fb_login_1_code
    code = params['code']
    access_token = fetch_access_token(code)
    render "/home"
  end

  def createfb
    token = params[:token]
    p token
    answer = 'no'
    if signed_in?
      answer = 'loggedin'
    else
      user = get_user_for_token token
      if !user.nil?
        sign_in user
        answer = session[:return_to] || '/home'
      end
    end
    respond_to do |format|
      format.text{
        render :text => answer;
      }
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

  private

    def fetch_access_token ( code )
      p code
      str_url = 'https://graph.facebook.com/oauth/access_token?'
      str_url += 'client_id=216988828315277'
      str_url += '&redirect_uri=' + @@ram_server + '/createfb'
      str_url += '&client_secret=' + @@fb_app_secret
      str_url += '&code=' + URI.escape(code)
      p str_url

    end

    def get_user_for_token(token)
      json_user = JSON.parse HTTParty.get('https://graph.facebook.com/me?access_token=' + URI.escape(token)).response.body
      user = User.find_by_fb_id json_user['id']
      if user.nil?
        user = User.new
        user.update_from_fb_json json_user
      end
      user.fb_token = token
      user.save
      user
    end

end