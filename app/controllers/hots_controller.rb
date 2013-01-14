class HotsController < ApplicationController
  def index
    @data = {
      :recent_contents => @user.recent_contents,
      :recent_betters => @user.recent_betters,
      :territories => @user.territories,
      :territory_outs => @user.territory_outs,
      :lang_id => @user.lang_id
    }
    @data[:title_users] = TitleUser.get_checks(@user.id) if @user.twitter_id
    #@data[:user] = {:tutorial_val => @user.tutorial_val}
    #@data[:tutorials] = @user.tutorials if @user.lang_id == 2
=begin
    @data[:themes] = Theme.where(:date => Date.today).map{|theme|theme.branch}
    @data[:canceled] = Leaf.where(:user_id => @user.id, :is_disabled => true).limit(8).order('id desc').map{|leaf|leaf.branch} if @user
=end
    @data[:home] = true if !params[:app_token]
  end

  def show
    if params[:id] == "updt_title_users"
      TitleUser.do_update(@user.id)
      redirect_to "/hots?app_token=#{@user.app_token}&user_id=#{@user.id.to_s}&lang_id=#{@user.lang_id.to_s}"
    elsif params[:id] == "move"
      if @user.id != current_user.id && @user.app_token != params[:app_token]
        raise "invalid app_token or session"
      else
        @word = Word.update(params[:branch_id], params)
      end
      redirect_to "/hots?app_token=#{params[:app_token]}&user_id=#{params[:user_id]}&lang_id=#{@user.lang_id.to_s}"
    end
  end
end
