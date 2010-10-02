# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_libra_session',
  :secret      => '2afcca5c3aabb7008a92e7b50b55265fe322f534d83570b896a87f5f9808630d41cbb36d549d3a1389e9fd6f0427056557fc5a7d9b60239ec59a68c8b7a15293'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
