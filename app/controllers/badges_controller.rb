class BadgesController < ApplicationController
  def index
    #render :json => (@user.tutorial.val - @user.tutorial_val)
    render :json => 0
  end
end
