# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_chipaga_session',
  :secret      => 'd4399b1568ac419aaac7a9918b5276c82cf24d04e04d749b20124f705da50ae28a31f9155e13d9dda106dd37f4d7c7550b3f65826dc36d8682a9a9ef6ffbc427'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
