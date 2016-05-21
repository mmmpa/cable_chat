require 'capybara_helper'

feature "Connect", :type => :feature do
  before :each do |ex|
    ready_ss(ex, 800)
  end

  let(:cookie) { "uuid=#{page.driver.cookies['uuid'].value}" }
  let(:ws) { WebSocket::Client::Simple.connect(mount_path, headers: {'Cookie' => cookie}) }
  let(:rejection_type) { ActionCable::INTERNAL[:message_types][:rejection] }
  let(:connected_type) { ActionCable::INTERNAL[:message_types][:welcome] }

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
    find('.room-member')

    received = {}
    ws.on :message do |data|
      received = JSON.parse(data.data)
    end

    wait_for { received }
    expect(received['type']).to eq(connected_type)
  end

end
