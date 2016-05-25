require 'rails_helper'

RSpec.describe User, :type => :model do
  it('test base data') { expect(build(:user).valid?).to be_truthy }

  describe 'validation' do
    subject { user.valid? }

    context 'name' do
      context 'require' do
        let(:user) { build(:user, name: nil) }
        it { should be_falsey }
      end

      context 'allow a 1' do
        context 'a' do
          let(:user) { build(:user, name: 'a') }
          it { should be_truthy }
        end

        context '1' do
          let(:user) { build(:user, name: '1') }
          it { should be_truthy }
        end
      end

      context 'deny not a 1' do
        context 'あ' do
          let(:user) { build(:user, name: 'あ') }
          it { should be_falsey }
        end

        context '&' do
          let(:user) { build(:user, name: '&') }
          it { should be_falsey }
        end
      end

      context 'length 1-10' do
        context 'min' do
          let(:user) { build(:user, name: '1') }
          it { should be_truthy }
        end

        context 'max' do
          let(:user) { build(:user, name: '1' * 10) }
          it { should be_truthy }
        end

        context 'under' do
          let(:user) { build(:user, name: '') }
          it { should be_falsey }
        end

        context 'over' do
          let(:user) { build(:user, name: '1' * 11) }
          it { should be_falsey }
        end
      end
    end

    context 'key' do
      let(:user) { build(:user, key: nil) }
      it('auto insert') { should be_truthy }
    end

    context 'uuid' do
      let(:user) { build(:user, uuid: nil) }
      it('auto insert') { should be_truthy }
    end
  end

  describe 'subscription' do
    let(:user) { create(:user, subscription: 5) }
    subject { user.subscription }

    context 'on subscribed' do
      before { user.subscribed }
      it { should eq(6) }
    end

    context 'on unsubscribed' do
      before { user.unsubscribed }
      it { should eq(4) }
    end

    context 'on exit' do
      before { user.exit! }
      it { should eq(0) }
    end
  end

  describe 'connection state' do
    context 'connected' do
      let(:user) { build(:user, subscription: 1) }
      subject { user.connected? }
      it { should be_truthy }
    end

    context 'disconnected' do
      let(:user) { build(:user, subscription: 0) }
      subject { user.disconnected? }
      it { should be_truthy }
    end
  end

  describe 'retrivation' do
    let(:user) { create(:user) }
    let(:params) { {name: SecureRandom.hex(2)} }
    subject { retrieved.name }

    context 'exist' do
      let(:retrieved) { User.retrieve_or_create!(user.uuid, params) }
      it { should eq(user.name) }
    end

    context 'not exist' do
      let(:retrieved) { User.retrieve_or_create!('invalid uuid', params) }
      it { should eq(params[:name]) }
    end
  end

  describe 'exit' do
    let(:user) { create(:user, subscription: 4) }
    before { user.exit! }

    context 'record destroyed' do
      subject { user.destroyed? }
      it { should be_truthy }
    end

    context 'subscription to 0' do
      subject { user.subscription }
      it { should eq(0) }
    end
  end
end
