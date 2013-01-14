class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :app_auth

  def app_auth
=begin
    session[:id]=nil
    if session[:id]
      @user = User.find(session[:id].to_i)
    elsif params[:app_token]
      @user = User.find_by_app_token(params[:app_token])
    elsif request.get? && params[:user_id]
      @user = User.find(params[:user_id].to_i)

    elsif params[:controller] != "index"
      redirect_to "/"
=end
    if user_signed_in?
      @user = current_user
    else
      @user = nil
    end
    @user.updt_lang_id(params[:lang_id]) if @user && params[:lang_id]
    user_id = (@user ? @user.id : 0 )
    LogAccess.plus(user_id, params)
  end
end
