class User < ApplicationRecord
  validates :name, :key, :uuid,
            presence: true

  validates :name,
            format: {with: /\A[A-Za-z0-9]+\Z/},
            length: {in: 1..10}

  before_validation :identify

  def identify
    self.key ||= SecureRandom.hex(8)
    self.uuid ||= SecureRandom.uuid
  end

  def subscribed
    self.subscription += 1
  end

  def unsubscribed
    self.subscription -= 1
    #destroy! if disconnected?
  end

  def disconnected?
    subscription == 0
  end
end
