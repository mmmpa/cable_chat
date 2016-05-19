require 'capybara_helper'

feature "Chat", :type => :feature do
  before :each do |ex|
    ready_ss(ex, 800)
  end

  scenario  do
    mount = Rails.application.config.action_cable.mount_path
    host = Capybara.app_host

    visit '/'
    take_ss('テスト', 0.1)
    find('.room-in-button').click
    take_ss('テスト', 0.1)

    ws = WebSocket::Client::Simple.connect(host + mount)

    ws.on :error do |e|
      p e
    end

    ws.on :message do |msg|
      puts msg.data
    end

    ws.on :open do
      p :open
      ws.send({command: "message", identifier: @identifier, data: {}.to_json})
    end
  end
end
