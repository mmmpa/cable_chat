require 'rails_helper'

RSpec.describe MemberChannel, :type => :model do
  let!(:user) { User.create!(name: 'abcd') }
  let!(:subscription) { user.subscription }
  let(:connection) { TestConnection.new(user) }
  let(:identifier) { {'channel' => 'MemberChannel'} }
  let(:channel) { MemberChannel.new(connection, identifier.to_json, identifier) }

  before { user.subscribed }

  context 'subscribed' do
    it 'start stream' do
      allow_any_instance_of(MemberChannel).to receive(:stream_from) { |instance, param|
        expect(param).to eq('member')
      }
      channel
    end
  end

  describe 'broadcast members' do
    before do
      allow(ActionCable.server).to receive(:broadcast) { |stream, data|
        expect([stream, data]).to eq(['member', members: [Member.create!(user).render]])
      }
    end

    context 'perform' do
      it 'broadcast to member' do
        channel.hello
      end
    end

    context 'unsubscribed' do
      it 'broadcast to member' do
        channel.unsubscribed
      end
    end
  end
end
