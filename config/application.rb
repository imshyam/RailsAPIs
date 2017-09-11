require_relative 'boot'

require 'rails/all'
require_relative 'get_current'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsAPIs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.after_initialize do
    	x = GetData.new.getResult
    	puts x
    end
  end
end
