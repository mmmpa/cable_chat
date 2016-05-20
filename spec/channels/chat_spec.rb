require 'capybara_helper'

def mount_path
  @mount_path ||= begin
    mount = Rails.application.config.action_cable.mount_path
    host = Capybara.current_session.server.host
    port = Capybara.current_session.server.port
    "http://#{host}:#{port}#{mount}"
  end
end

def wait_for(wait = 2, &block)
  start = Time.now.to_i
  store = block.()
  loop do
    break if block.() != store || Time.now.to_i - start > wait
  end
end

feature "Connect", :type => :feature do
  before :each do |ex|
    ready_ss(ex, 800)
  end

  let(:ws) { WebSocket::Client::Simple.connect(mount_path) }
  let(:rejection_type) { ActionCable::INTERNAL[:message_types][:rejection] }

  scenario 'reject when no session' do
    received = {}
    ws.on :message do |data|
      received = JSON.parse(data.data)
    end

    wait_for { received }
    expect(received['type']).to eq(rejection_type)
  end

  scenario 'receive my data when has session' do
    visit '/'
    find('.room-in-name').set('aaaa')
    find('.room-in-button').click

    received = {}
    ws.on :message do |data|
      received = JSON.parse(data.data)
    end

    wait_for { received }
    expect(received['type']).to eq(rejection_type)
  end

end
