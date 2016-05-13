class User < ApplicationRecord
  validates :name, :key, :uuid,
            presence: true

  before_validation :identify

  def identify
    self.key ||= SecureRandom.hex(8)
    self.uuid ||= SecureRandom.uuid
  end
end
