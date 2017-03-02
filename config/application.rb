require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pizzaprimeweb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Koala.config.api_version = 'v2.0'

    PagarMe.api_key = "ak_live_TPo8vQTEVD2oJ59IIYY9ekkYG7oBiS"
  end
end
