# coding: utf-8

class TitlesController < ApplicationController
  # GET /titles
  def index
    render json: Title.id_name
  end

  # GET /titles/hoge.json
  def show
    keywords = params[:id].split(/\s+|　+/)

    title_table = Title.arel_table
    conds = nil

    keywords.each do |keyword|
      cond = title_table[:name].matches("%#{keyword}%")
      if conds.present?
        conds = conds.or(cond)
      else
        conds = cond
      end 
    end

    titles = Title.where("url_id is null and is_ng = 0").where(conds).map{|title|title.id}
    @words = Branch.where(
      "leaf_num > 0", 
    ).where(
      :title_id => titles,
      :lang_id => params[:lang_id].to_i
    ).limit(50).order('leaf_num desc').map do |branch|
      {
        :branch_id => branch.id,
        :leaf_num => branch.leaf_num,
        :title => branch.title.name,
        :breadcrumbs => branch.breadcrumbs
      }
    end
    render json: @words
  end

end
