class FacebookController < ApplicationController

  require 'json'
  require 'net/https'
  require 'uri'

  def start
    code = params['code']
    p code

    query = 'client_id=216988828315277&'
    query += 'redirect_uri=http://rob.wildgigs.com/facebook/callback&'
    query += 'client_secret=fa38f03c9206cfe4888d713fa0dff65e&'
    query += 'code=' + code

    http = Net::HTTP.new('https://graph.facebook.com', 80)
    http.use_ssl = true

    request = Net::HTTP::Get.new('/oauth/access_token' + "?" + query)
    response = http.request(request)
    data = response.body

    p data
    p '------'
    p data.split("=")[1]

  end

  def callback

  end




#  def start
#    redirect client.web_server.authorize_url(
#      :redirect_uri => redirect_uri,
#      :scope => 'email,offline_access'
#    )
#  end
#
#  def callback
#    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
#    p access_token
#    user = JSON.parse(access_token.get('/me'))
#    user.inspect
#    p user
#  end
#
#  def client
#    OAuth2::Client.new('216988828315277',
#                       'fa38f03c9206cfe4888d713fa0dff65e',
#                       :site => 'https://graph.facebook.com')
#  end
#
#  def redirect_uri
##    uri = URI.parse(request.url)
#    uri.path = 'http://rob.wildgigs.com/facebook/callback'
#    uri.query = nil
#    uri.to_s
#  end

end
