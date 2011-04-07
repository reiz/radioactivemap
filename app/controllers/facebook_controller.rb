class FacebookController < ApplicationController

  layout "plain"

  def start
    code = params['code']

    domain = 'https://graph.facebook.com'
    uri = '/oauth/access_token'
    query = 'client_id=216988828315277&'
    query += 'redirect_uri=http://radioactive-map.com/facebook/start&'
    query += 'client_secret=fa38f03c9206cfe4888d713fa0dff65e&'
    query += 'code=' + code
    link = domain + uri + '?' + query

    response = HTTParty.get(URI.encode(link))

    data = response.body
    access_token = data.split("=")[1]

    user = get_user_for_token access_token
    if !user.nil?
      sign_in user
    end
  end

  private

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
