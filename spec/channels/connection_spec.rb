require 'rails_helper'

RSpec.describe MessageChannel, :type => :model do
  let!(:user) { User.create!(name: 'abcd') }
  let(:connection) { started_connection }
  let(:unstarted_connection) { setup_connection }

  describe 'starting' do
    context 'has session' do
      it 'set current_user' do
        allow(User).to receive(:find_by) { user }
        expect(connection.current_user).to eq(user)
      end
    end

    context 'no session' do
      it 'reject' do
        allow(unstarted_connection).to receive(:transmit) { |**params|
          expect(params[:type]).to eq(ActionCable::INTERNAL[:message_types][:rejection])
        }
        unstarted_connection.process
        unstarted_connection.send(:handle_open)
      end
    end
  end

  describe 'closing' do
    context 'try close' do
      it 'transmit rejection' do
        allow(connection).to receive(:transmit) { |**params|
          expect(params[:type]).to eq(ActionCable::INTERNAL[:message_types][:rejection])
        }
        connection.close
      end
    end
  end
end

def mock_env
  Rack::MockRequest.env_for(
    '/',
    'HTTP_CONNECTION' => 'upgrade',
    'HTTP_UPGRADE' => 'websocket',
    'HTTP_HOST' => 'localhost',
    'HTTP_ORIGIN' => 'http://localhost'
  )
end

def setup_connection
  ApplicationCable::Connection.new(TestServer.new(subscription_adapter: SuccessAdapter), mock_env)
end

def started_connection
  connection = setup_connection
  connection.process
  connection.send(:handle_open)
  connection
end