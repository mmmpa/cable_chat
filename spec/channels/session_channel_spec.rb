require 'rails_helper'

RSpec.describe SessionChannel, :type => :model do
  let!(:user) { User.create!(name: 'abcd') }
  let!(:subscription) { user.subscription }
  let(:connection) { TestConnection.new(user) }
  let(:identifier) { {'channel' => 'SessionChannel'} }
  let!(:channel) { SessionChannel.new(connection, identifier.to_json, identifier) }

  context 'subscribed' do
    it 'increment user subscription' do
      expect(user.subscription).to eq(subscription + 1)
    end
  end

  context 'unsubscribed' do
    it 'decrement user subscription' do
      subscription = user.subscription
      channel.unsubscribed
      expect(user.subscription).to eq(subscription - 1)
    end
  end

  context 'exited' do
    before { channel.exit }

    it 'user destroyed' do
      expect(user.destroyed?).to be_truthy
    end

    it 'user subscription is 0.' do
      expect(user.subscription).to eq(0)
    end

    it 'call connection exit' do
      expect(connection.exited).to be_truthy
    end
  end
end
