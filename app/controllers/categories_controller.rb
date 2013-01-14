# coding: UTF-8

class CategoriesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :index ]
  caches_page :index, :show, :unless => Proc.new { |c| c.request.user_agent =~ /iPhone|iPod/ } 

  USER_ID = 1

  before_filter :miniprofiler
  
  def miniprofiler
    if Rails.env == 'development'
      Rack::MiniProfiler.authorize_request
    end
  end

  def index
    lang_id = 2

    # smart phone
    if request.user_agent =~ /iPhone|iPod/
      @branch = Branch.find(lang_id)
      return redirect_to root_url if @branch.nil?
      redirect_to :action => :show, :id => @branch.id
      return
    end

    # cache
    path = "#{Rails.root}/tmp/caches/index.html"
    if File.exist?(path)
      content = open(path).read
      render :text => content, :content_type => Mime::HTML 
      return
    end

    # index 
    @topics = []
    Topic.where(:lang_id => lang_id).order("updated_at DESC").limit(10).each do |topic|
      @topics << Branch.get(topic.branch_id)
    end

    word = Word.show(USER_ID, lang_id)
    @categories = word[:children]

    @categories.reject! { |c| c[:branch_id] == 15032 }

    @children = {}
    @children.default = []

    @categories.each do |child|
      branch = Branch.find_by_id(child[:branch_id])
      next if branch.nil?
      @children[branch.id] = branch.children_hash(USER_ID)[0..9]
    end

    @parents = word[:breadcrumbs].reverse

  end

  def show

    # smart phone
    if request.user_agent =~ /iPhone|iPod/
      @branch = Branch.find(params[:id].to_i)
      return redirect_to root_url if @branch.nil?
      render "itunes/show", :layout => "application"
      return
    end

    # cache
    path = "#{Rails.root}/tmp/caches/#{params[:id].to_i}.html"
    if File.exist?(path)
      content = open(path).read
      render :text => content, :content_type => Mime::HTML 
      return
    end

    branch = Branch.get(params[:id].to_i)
    return redirect_to root_url if branch.nil?

    word = Word.show(USER_ID, params[:id].to_i)
    @categories = word[:children]
    @parents = word[:breadcrumbs].reverse

    @title = branch.title.name 
    @leafNum = branch.leaf_num

    @contents = Content.get(params[:id].to_i, USER_ID)
    @contents.reject! { |c| c[:content].blank? } 
    @contents = @contents[0..2] 
  end

  # See also: titles_controller#show
  def search
    lang_id = 2

    keywords = params[:q].split(/\s+|　+/)

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
      :lang_id => lang_id
    ).limit(50).order('leaf_num desc').map do |branch|
      {
        :branch_id => branch.id,
        :leaf_num => branch.leaf_num,
        :title => branch.title.name,
        :breadcrumbs => branch.breadcrumbs
      }
    end

    @title = params[:q] 
    @leafNum = @words.count 
    @categories = @words
  end

end
