# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_realstories_session',
  :secret      => 'cf86a954228a32f0c1ea97d6780a9180eda9f80643af6b06e36c58f7a7ef57e2f160b6c9b15e199bc367cbf9d0895b0ad42ed654ca1d95826ba3896a3e807693'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
