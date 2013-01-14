class BookmarksController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :index ]
  layout 'bookmarks'

  def index
    respond_to do |format|
      format.html {
        redirect_to user_omniauth_authorize_path(:twitter) if @user.nil?
      }

      format.xml { 
        offset = 0 
        limit = params[:n].blank? ? 10 : params[:n].to_i 

        bookmarks = @user.bookmarks.order("updated_at DESC").offset(0).limit(limit).map { |b| b.branch }

        result = bookmarks.map do |branch|
          h = {   
            :branch_id => branch.id,
            :title => branch.title.name,
            :breadcrumbs => branch.breadcrumbs,
          }   
          h
        end 

        render :xml => result.to_plist
      }
    end
  end

  def create
    bookmark = @user.bookmarks.find_or_create_by_branch_id(params[:branch_id].to_i)
    bookmark.save
    render :json => { :status => 'OK' }
  end

  def destroy
    bookmark = @user.bookmarks.find_by_branch_id(params[:id].to_i)
    bookmark.delete
    render :json => { :status => 'OK' }
  end

end
