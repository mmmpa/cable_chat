require 'capybara_helper'


feature "Connect", :type => :feature do
  let(:cookie) { "uuid=#{page.driver.cookies['uuid'].value}" }
  let(:ws) { WebSocket::Client::Simple.connect(mount_path, headers: {'Cookie' => @cookie}) }
  let(:rejection_type) { ActionCable::INTERNAL[:message_types][:rejection] }
  let(:connected_type) { ActionCable::INTERNAL[:message_types][:welcome] }


  feature 'when has session' do
    scenario 'connect' do
      @cookie = uuid_cookie(User.create!(name: 'aaaa').uuid)

      received = []
      ws.on :message do |data|
        received.push JSON.parse(data.data)
      end

      wait_for { received }
      expect(received[0]['type']).to eq(connected_type)
    end

    scenario 'receive my data' do
      @cookie = uuid_cookie(User.create!(name: 'abcd').uuid)

      received = []
      ws.on :message do |data|
        received.push JSON.parse(data.data)
      end

      wait_for { received }
      ws.send(make_subscribe('SessionChannel'))
      result = wait_for_matching {
        received.select { |m|
          m['message'] && m['message']['me']
        }.first
      }
      expect(result['message']['me']['name']).to eq('abcd')
    end
  end

  feature 'when no session' do
    scenario 'reject' do
      received = []
      ws.on :message do |data|
        received.push JSON.parse(data.data)
      end

      wait_for { received }
      expect(received[0]['type']).to eq(rejection_type)
    end
  end
end
