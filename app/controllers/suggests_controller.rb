class SuggestsController < ApplicationController
  def index
    @titles = Title.suggest(params[:title])
    render json: @titles 
  end
end
