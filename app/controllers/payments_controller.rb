class PaymentsController < ApplicationController

def create
  receipt = params[:receipt] 

  if receipt.blank?
    render :json => { status => "ng" }
    return
  end

  env = Rails.env == 'production' ? 'buy' : 'sandbox'

  uri = URI.parse("https://#{env}.itunes.apple.com/verifyReceipt")

  response = nil
  
  request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
  request.body = { "receipt-data" => receipt }.to_json

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  http.start do |h|
    response = h.request(request)
    body = JSON.parse(response.body)

    if body["status"] == 0
      expire_date = Time.at(params[:expire_date].to_f)
      @user.premium_expired_at = expire_date
      @user.save

      render :json => { :status => "ok", :days => @user.premium_expire_days }
    end
    return
  end

  render :json => { status => "ng" }
  return
end

end
