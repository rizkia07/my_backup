# Be sure to restart your server when you modify this file.

#Tree::Application.config.session_store :cookie_store, key: '_tree_session'
Tree::Application.config.session_store :active_record_store

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Tree::Application.config.session_store :active_record_store
