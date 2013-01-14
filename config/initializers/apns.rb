APNS.host = Rails.env == 'production' ? 'gateway.push.apple.com' : 'gateway.sandbox.push.apple.com'

APNS.pem  = "#{Rails.root}/config/cert/apns_#{Rails.env}.pem"
APNS.port = 2195 
