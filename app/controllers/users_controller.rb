# -*r coding: utf-8 -*-
class UsersController < ApplicationController
  # POST /users.json
  def create
    @user = User.add
    render json: @user
  end

  # PUT /users.json
  def update
    #TODO
    if params[:device_token]
      @user.device_token = params[:device_token]
      @user.save
      render :text => 'OK'
    end
  end

  def app_tw_auth
    if params[:app_token]
      if user = User.find_by_app_token(params[:app_token])
        session[:tmp_id] = user.id
        session[:is_app] = true
        redirect_to '/auth/twitter'
      else
        raise "invalid user"
      end
    else
      raise "you need app_token"
    end
  end

  def import
    require 'csv'
    CSV.open("tmp/csv/file3.csv","r") do |csv|
      csv.each do |i|
        raise i.inspect
      end
    end
  end



  def export
=begin
    require 'kconv'
    require 'csv'
    columns = User.all
    file_name = Kconv.kconv("sample.csv", Kconv::SJIS)
    header = ["id", "名前", "登録日"]

    csv_data = CSV.generate("", {:row_sep => "\r\n", :headers => header, :write_headers => true}) do |csv|
      columns.each do |line|
        column = []
        column << line[:id]
        column << line[:name]
        column << line[:created_at].strftime("%Y年%m月%d日")
        csv << column
      end
    end

    csv_data = csv_data.tosjis
    send_data(csv_data, :type => 'text/csv; charset=shift_jis; header=present', :filename => file_name)
=end
  end

  def tw_callback
    @auth = request.env["omniauth.auth"]
    if !session[:is_app]
      user = User.get_via_twitter_auth(@auth)
      session[:id] = user.id
      redirect_to '/'
    else
      if @auth[:info][:nickname]
        user = User.find_by_twitter_id(@auth[:uid]) #43 
        session_user = User.find(session[:tmp_id]) #68
        if user && user.id != session_user.id 
          User.merge(session_user.id, user.id)
          user.merge_premium(session_user)
          user.merge_device(session_user)
        else
          user = session_user
        end
        user.update_via_twitter_auth(@auth)
        res = {}
        res[:user_id] = user.id
        res[:screen_name] = @auth[:info][:nickname]
        res[:app_token] = user.app_token
        res[:expire_date] = user.premium_expired_at.to_f unless user.premium_expired_at.nil?
      else
        res = false
      end
      render :json => res
    end
  end

  def tw_callback_fail
    render :json => false
  end

  def logout
    id = session[:id]
    session.destroy
    #redirect_to '/'
    redirect_to '/users/app_tw_auth?user_id='  + id.to_s
  end
end
