class BranchesController < ApplicationController
  # GET /branchs
  def index
    if params[:user_id].to_i > 0
      @branches = Branch.ids_by_user(
        params[:user_id].to_i
      )
    else
      @branches = Branch.all_data
    end
    render json: @branches
  end
end
