require 'rails_helper'

RSpec.describe User, :type => :model do
  it('test base data') { expect(build(:user).valid?).to be_truthy }

  describe 'validation' do
    context 'name' do
      it('require') { expect(build(:user, name: nil).valid?).to be_falsey }

      context 'allow a 1' do
        it('a') { expect(build(:user, name: 'a').valid?).to be_truthy }
        it('1') { expect(build(:user, name: '1').valid?).to be_truthy }
      end

      context 'deny not a 1' do
        it('あ') { expect(build(:user, name: 'あ').valid?).to be_falsey }
        it('&') { expect(build(:user, name: '&').valid?).to be_falsey }
      end

      context 'length 1-10' do
        it { expect(build(:user, name: 'a').valid?).to be_truthy }
        it { expect(build(:user, name: 'a' * 10).valid?).to be_truthy }
        it('long') { expect(build(:user, name: 'a' * 11).valid?).to be_falsey }
        it('short') { expect(build(:user, name: '').valid?).to be_falsey }
      end
    end

    context 'key' do
      it('auto insert') { expect(build(:user, key: nil).valid?).to be_truthy }
    end

    context 'uuid' do
      it('auto insert') { expect(build(:user, uuid: nil).valid?).to be_truthy }
    end
  end
end
