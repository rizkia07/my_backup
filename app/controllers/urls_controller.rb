class UrlsController < ApplicationController

def show
  url = Url.find_or_initialize_by_url(params[:location])

  result = {}   

  if url && url.titles.present?

    branch = Branch.where(
      "leaf_num > 0", 
    ).where(
      :title_id => url.titles.first.id,
      #:lang_id => params[:lang_id].to_i
    ).order('leaf_num desc').first

    #word = Word.show(1, branch.id)

    result = {   
      :branch_id => branch.id,
      :title => branch.title.name,
      :breadcrumbs => branch.breadcrumbs
    }   
  end
  render :json => result
end

end

