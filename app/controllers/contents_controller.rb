class ContentsController < ApplicationController
  def index
    if params[:word_id].to_i == 0
      @contents = nil
    else
      if params[:user_id]
        user_id = params[:user_id]
      else
        user_id = current_user.id
      end
      @contents = Content.get(params[:word_id], user_id)
    end
    render :json => @contents
  end
end
