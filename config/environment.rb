# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml', :lib => 'haml', :version => '>=2.2.0'
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'authlogic'
  config.gem 'rpx_now'
  config.gem 'authlogic_rpx'
  config.gem 'RedCloth'
  config.gem 'will_paginate'
  config.gem 'rakismet'
  config.gem 'gravtastic'
  config.gem 'haml'
  config.gem 'compass'
  config.gem "cancan"
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  # config.action_controller.session_store = :active_record_store 
  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  # remove these if source is posted
  ENV['RECAPTCHA_PUBLIC_KEY']  = '6Ld5lwkAAAAAAFWUJsL2Ph_PC1bhShyNN74QacNx'
  ENV['RECAPTCHA_PRIVATE_KEY'] = '6Ld5lwkAAAAAADC02Pe02avlt4dyN7muiapF-lU_'

  ENV['RPX_API_KEY'] = '76959c3e485a41b7c16b041fe216aef19572f5ed'
  RPX_API_KEY = ENV['RPX_API_KEY']
  RPX_APP_NAME = 'realstories'
end