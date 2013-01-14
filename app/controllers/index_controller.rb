class IndexController < ApplicationController
  def index
    redirect_to '/hots' if session[:id]
  end

  def help
  end

  def api
    render "api", :layout => "api"
  end
  
  def all_data
    @all_data = {
      :titles => Title.id_name,
      :branches => Branch.all_data,
      :user_branches => Branch.ids_by_user(params[:user_id].to_i)
    }
    render json: @all_data
  end

  def welcome
    @lang = "en"
    @lang = "ja" if params[:lang_id].to_i == 2
  end
end
