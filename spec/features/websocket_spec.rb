require 'capybara_helper'


feature "Connect", :type => :feature do
  let(:user) { User.create!(name: 'abcd') }
  let(:cookie) { "uuid=#{page.driver.cookies['uuid'].value}" }
  let(:ws) { WebSocket::Client::Simple.connect(mount_path, headers: {'Cookie' => uuid_cookie(user.uuid)}) }
  let(:ws_no_uuid) { WebSocket::Client::Simple.connect(mount_path) }
  let(:rejection_type) { ActionCable::INTERNAL[:message_types][:rejection] }
  let(:connected_type) { ActionCable::INTERNAL[:message_types][:welcome] }


  feature 'has session' do
    scenario 'connect and receive me' do
      received = []

      ws.on :message do |data|
        received.push JSON.parse(data.data)
      end

      wait_for { received }

      expect(received.first['type']).to eq(connected_type)

      ws.send(make_subscribe('SessionChannel'))

      result = wait_for_matching {
        received.select { |m|
          !m['type'] && m['message']['me']
        }.first
      }

      expect(result['message']['me']['name']).to eq('abcd')
    end
  end

  feature 'no session' do
    scenario 'reject' do
      received = []
      ws_no_uuid.on :message do |data|
        received.push JSON.parse(data.data)
      end

      wait_for { received }
      expect(received[0]['type']).to eq(rejection_type)
    end
  end

  feature 'connected' do
    scenario 'receive member' do
      User.create!(name: '1234').subscribed
      received = []
      ws.on :message do |data|
        received.push JSON.parse(data.data)
      end
      wait_for { received }

      ws.send(make_subscribe('SessionChannel'))

      wait_for_matching {
        received.select { |m|
          m['type'] == 'confirm_subscription' && m['identifier'].include?('SessionChannel')
        }.first
      }

      ws.send(make_subscribe('MemberChannel'))
      ws.send(make_perform('MemberChannel', 'hello'))

      result = wait_for_matching {
        received.select { |m|
          !m['type'] && m['message']['members']
        }.first
      }

      expect(result['message']['members'].map { |m| m['name'] }).to eq(['1234', 'abcd'])
    end

    scenario 'send message and receive' do
      received = []
      ws.on :message do |data|
        received.push JSON.parse(data.data)
      end
      wait_for { received }

      ws.send(make_subscribe('MessageChannel'))
      ws.send(make_message('MessageChannel', {message: 'Hi', x: 1, y: 2}))

      result = wait_for_matching {
        received.select { |m|
          !m['type'] && m['message']['message']
        }.first
      }

      expect(result['message']['message']['name']).to eq('abcd')
      expect(result['message']['message']['message']).to eq('Hi')
    end

    scenario 'disconnect' do
      received = []
      ws.on :message do |data|
        received.push JSON.parse(data.data)
      end
      wait_for { received }

      ws.send(make_subscribe('SessionChannel'))

      wait_for_matching {
        received.select { |m|
          m['type'] == 'confirm_subscription' && m['identifier'].include?('SessionChannel')
        }.first
      }
      received.delete_if { true }

      ws.send(make_perform('SessionChannel', 'exit'))

      wait_for_matching {
        received.select { |m|
          m['type'] == rejection_type
        }.first
      }
    end
  end
end
