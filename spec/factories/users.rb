FactoryGirl.define do
  factory :user do
    name { SecureRandom.hex(2) }
    key { SecureRandom.hex(8) }
    uuid { SecureRandom.uuid }
  end
end
