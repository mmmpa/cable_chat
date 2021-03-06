class User < ApplicationRecord
  validates :name, :key, :uuid,
            presence: true

  validates :name,
            format: {with: /\A[A-Za-z0-9]+\Z/},
            length: {in: 1..10}

  before_validation :identify

  scope :in, -> { where('subscription > 0') }

  class << self
    def retrieve_or_create!(uuid, params)
      find_by(uuid: uuid) || create!(params)
    end
  end

  def identify
    self.key ||= SecureRandom.hex(8)
    self.uuid ||= SecureRandom.uuid
  end

  def subscribed
    self.subscription += 1
    save
  end

  def exit!
    self.subscription = 0
    save
    destroy!
  end

  def unsubscribed
    return if disconnected?

    self.subscription -= 1
    save
  end

  def connected?
    subscription != 0
  end

  def disconnected?
    subscription == 0
  end

  class Already < StandardError

  end
end
