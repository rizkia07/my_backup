class InquiriesController < ApplicationController
  def create
    @viewer = User.find(params[:user_id].to_i)
    if @viewer.id != current_user.id && @viewer.app_token != params[:app_token]
      raise "invalid app_token or session"
    else
      @word = Inquiry.create(params)
    end
    @data = params
    render json: true
  end
end
