# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mailer_session',
  :secret      => '3ee1c15f008c8f826f91f0bc9a7dd860f07b6c4c150ca9e95e5865b453fbc368ea0dafb98b06f1b8353be291cd17e0bc8e535e93d7401ec78801f7c7f497d482'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
