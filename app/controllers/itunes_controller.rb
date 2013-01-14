class ItunesController < ApplicationController
  def show
    @branch = Branch.find(params[:id].to_i)
  end
end
