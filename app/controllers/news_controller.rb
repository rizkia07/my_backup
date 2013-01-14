class NewsController < ApplicationController
  def index
    render :layout => false
  end

  def topic_create
    topic = Topic.new
    topic.branch_id = params[:branch_id].to_i
    topic.lang_id = params[:lang_id].to_i
    topic.save!

    render :text => "OK"
  end

  def notification_create

    User.all.each do |user|
      notification = Notification.new
      notification.branch_id = params[:branch_id].to_i
      notification.lang_id = params[:lang_id].to_i
      notification.title = params[:title].to_s
      notification.body = params[:body].to_s
      notification.user_id = user.id
      notification.save!
    end

    render :text => "OK"
  end


private
  def auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == 'hogehoge' && pass == 'fugafuga'
    end
  end

end

