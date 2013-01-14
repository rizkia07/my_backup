module ApplicationHelper
  
  def alerts
    unless flash[:alert].blank?
      render :partial => 'shared/error_message', :locals => {:message => flash[:alert] }
		end
		
		unless flash[:notice].blank?
      render :partial => 'shared/success_message', :locals => {:message => flash[:notice] }
		end
	end
	
end