require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CableChat
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_cable.mount_path = '/cable'
    #config.action_cable.allowed_request_origins = [/http:\/\/localhost:*/]

    config.browserify_rails.commandline_options = '-t babelify'

    config.generators do |g|
      g.assets false
      g.helper false
      g.view false

      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false
      g.fixture_replacement :factory_girl,
                            dir: 'spec/factories'
    end
  end
end
