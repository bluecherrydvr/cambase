class UsersController < ApplicationController

  def auth
    code = params[:code]
    
    connection = Faraday.new(url: 'https://api.evercam.io') do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    parameters = {
      redirect_uri: "http://www.cambase.io/users/auth",
      code: code,
      client_id: '3d0e289b',
      client_secret: ENV['EVERCAM_KEY'],
      grant_type: 'authorization_code'
    }
    response = connection.post '/oauth2/authorize', parameters

    access_token = JSON.parse(response.body)['access_token']

    response = connection.get "/oauth2/tokeninfo?access_token=#{access_token}"

    user_id = JSON.parse(response.body)['userid']

    response = connection.get do |request|
      request.url "/v1/users/#{user_id}"
      request.headers['Authorization'] = "bearer #{access_token}"
    end

    evercam_user = JSON.parse(response.body)['users'][0]

    user = User.where(username: evercam_user['id']).first_or_initialize
    user.update_attributes(email: evercam_user['email'])
    sign_in(user)
    redirect_to after_sign_in_path_for(user)
  end

end
