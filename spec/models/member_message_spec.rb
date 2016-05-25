require 'rails_helper'

RSpec.describe MemberMessage, :type => :model do
  let(:user) { create(:user) }

  describe 'validation' do
    subject { message.valid? }

    context 'user' do
      context 'require' do
        context do
          let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
          it { should be_truthy }
        end

        context do
          let(:message) { MemberMessage.create!(nil, 'm', 1, 1) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end
    end

    context 'message' do
      context 'require' do
        context do
          let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
          it { should be_truthy }
        end

        context do
          let(:message) { MemberMessage.create!(user, nil, 1, 1) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end

      context 'length 1..140' do
        context 'min' do
          let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
          it { should be_truthy }
        end

        context 'max' do
          let(:message) { MemberMessage.create!(user, 'm' * 140, 1, 1) }
          it { should be_truthy }
        end

        context 'under' do
          let(:message) { MemberMessage.create!(user, '', 1, 1) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end

        context 'over' do
          let(:message) { MemberMessage.create!(user, 'm' * 141, 1, 1) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end
    end

    context 'x' do
      context 'require' do
        context do
          let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
          it { should be_truthy }
        end

        context do
          let(:message) { MemberMessage.create!(user, 'm', nil, 1) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end

      context 'allow only number' do
        context 'number' do
          let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
          it { should be_truthy }
        end

        context 'not number' do
          let(:message) { MemberMessage.create!(user, 'm', 'a', 1) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end
    end

    context 'y' do
      context 'require' do
        context do
          let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
          it { should be_truthy }
        end

        context do
          let(:message) { MemberMessage.create!(user, 'm', 1, nil) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end

      context 'allow only number' do
        context do
          let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
          it { should be_truthy }
        end

        context do
          let(:message) { MemberMessage.create!(user, 'm', 1, 'a') }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end
    end
  end

  describe 'rendering' do
    context 'keys' do
      let(:message) { MemberMessage.create!(user, 'm', 1, 1) }
      subject { message.render.keys }

      it { should match_array([:name, :user_key, :key, :message, :x, :y]) }
    end
  end
end
