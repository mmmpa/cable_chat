class User < ApplicationRecord
  validates :name, :key, :uuid,
            presence: true

  validates :name,
            format: {with: /\A[A-Za-z0-9]+\Z/},
            length: {in: 1..10}

  before_validation :identify

  scope :in, -> { where('subscription > 0') }

  def identify
    self.key ||= SecureRandom.hex(8)
    self.uuid ||= SecureRandom.uuid
  end

  def subscribed
    self.subscription += 1
    self.save
  end

  def unsubscribed
    unless destroyed?
      self.subscription -= 1
      self.save
    end
  end

  def disconnected?
    subscription == 0
  end
end
