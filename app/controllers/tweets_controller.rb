class TweetsController < ApplicationController

def create
  twitter_client = Twitter::Client.new(
    :oauth_token        => @user.twitter_token,
    :oauth_token_secret => @user.twitter_secret
  )
  response = twitter_client.update(params[:body])

  screen_name = response[:user][:screen_name]
  id = response[:id]

  render :json => { :uri => "https://twitter.com/#{screen_name}/status/#{id}" }
end

end
