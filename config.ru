# This file is used by Rack-based servers to start the application.
=begin
Tree::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Baton] ",
  :sender_address => %{"notifier" <notifier@mindia.jp>},
  :exception_recipients => %w{exceptions@mindia.jp}
=end
require ::File.expand_path('../config/environment',  __FILE__)
run Tree::Application




