require 'rails_helper'

RSpec.describe Member, :type => :model do
  let(:user) { create(:user) }

  describe 'validation' do
    subject { member.valid? }

    context 'user' do
      context 'require' do
        context do
          let(:member) { Member.create!(user) }
          it { should be_truthy }
        end

        context do
          let(:member) { Member.create!(nil) }
          it { expect { subject }.to raise_error(ActiveModel::StrictValidationFailed) }
        end
      end
    end
  end

  describe 'rendering' do
    context 'keys' do
      let(:member) { Member.create!(user) }
      subject { member.render.keys }

      it { should match_array([:name, :key]) }
    end
  end
end
