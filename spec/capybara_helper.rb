require 'rails_helper'
require 'capybara'
require 'capybara/rspec'
require 'capybara/poltergeist'

Dir[Rails.root.join('spec/capybara/**/*.rb')].each { |f| require f }

#Capybara.app_host = 'http://localhost:3001'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    js_errors: false,
    timeout: 1000,
    debug: false,
    phantomjs_options: %w(
      --load-images=no
      --ignore-ssl-errors=yes
      --ssl-protocol=any
    )})
end
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

ScreenShotMan.dir = "#{Rails.root}/log/ss"
