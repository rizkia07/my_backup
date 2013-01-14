class ColumnsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    redirect_to user_omniauth_authorize_path(:twitter) if @user.nil?
  end

end
