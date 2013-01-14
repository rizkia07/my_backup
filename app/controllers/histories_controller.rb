class HistoriesController < ApplicationController

  # GET /histories.xml
  def index
    respond_to do |format|
      format.xml { 
        offset = 0 
        limit = params[:n].blank? ? 10 : params[:n].to_i 

        #histories = @user.log_access_words.group(:branch_id).where("branch_id > ?", 100).order("updated_at DESC").offset(offset).limit(limit)
        histories = @user.log_access_words.group(:branch_id).where("branch_id > ?", 100).order("maximum_updated_at DESC").offset(0).limit(limit).maximum(:updated_at).map { |k, v| Branch.find(k) }

=begin
        result = histories.map do |history|
          h = {   
            :branch_id => history.branch.id,
            :title => history.branch.title.name,
            :breadcrumbs => history.branch.breadcrumbs,
          }   
          h[:url_name] = history.branch.title.url.name if history.branch.title.url_id
          h
        end 
=end
        histories.reject! { |branch| branch.title.url? } 

        result = histories.map do |branch|
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

end
