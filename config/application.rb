require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsAPIs
  class Application < Rails::Application
  	#For API only
  	config.api_only = true
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
  end
end
