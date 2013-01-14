require "amazon/ecs"

# loggerにdebug printを出す
Amazon::Ecs.debug = true

Amazon::Ecs.configure do |options|
  options[:response_group] = 'Large'
  options[:AWS_access_key_id] = 'AKIAIOV5WSIBRLHLWEZA'
  options[:AWS_secret_key] = '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'
  options[:associate_tag] = 'mindia-22'
end


