class FavsController < ApplicationController
  # POST /leafs/1/favs.json
  def create
    @fav = Fav.create(params[:favs], params[:leaf_id])
    render json: @fav 
  end

  # DEL /leafs/1/favs.json
  def destroy
    @fav = Fav.destroy(params[:favs], params[:leaf_id])
    render json: @fav 
  end
end
