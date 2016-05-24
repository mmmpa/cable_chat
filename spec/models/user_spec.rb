require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { build(:user, :valid) }

  context 'require' do
    context 'name' do
      it {}
    end
    context 'key'
    context 'uuid'
  end

  context 'name' do
    context 'allow' do

    end

    context 'deny' do

    end

    context 'length 1-10' do

    end
  end
end
