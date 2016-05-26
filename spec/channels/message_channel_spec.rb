require 'rails_helper'

RSpec.describe MessageChannel, :type => :model do
  let!(:user) { User.create!(name: 'abcd') }
  let!(:subscription) { user.subscription }
  let(:connection) { TestConnection.new(user) }
  let(:identifier) { {'channel' => 'MessageChannel'} }
  let(:channel) { MessageChannel.new(connection, identifier.to_json, identifier) }

  before { user.subscribed }

  context 'subscribed' do
    it 'start stream' do
      allow_any_instance_of(MessageChannel).to receive(:stream_from) { |instance, param|
        expect(param).to eq('message')
      }
      channel
    end
  end

  describe 'broadcast new message' do
    let(:valid_hash) { {message: 'message', x: 1, y: 2}.stringify_keys }
    let(:invalid_hash) { {message: 'a' * 400, x: 1, y: 2}.stringify_keys }
    let(:valid_data) { ['message', 1, 2] }

    context 'valid message received' do
      it 'broadcast message' do
        allow(ActionCable.server).to receive(:broadcast) { |stream, data|
          data[:message].delete(:key)
          message = MemberMessage.create!(user, *valid_data).render
          message.delete(:key)
          expect([stream, data]).to eq(['message', message: message])
        }
        channel.receive(valid_hash)
      end
    end

    context 'invalid message received' do
      it 'raise error' do
        expect { channel.receive(invalid_hash) }.to raise_error(ActiveModel::StrictValidationFailed)
      end
    end
  end
end
