class MemberMessage
  include ActiveModel::Validations

  attr_accessor :user, :message, :x, :y

  validates! :user, :message, :x, :y,
             presence: true
  validates! :message,
             length: {in: 1..140}
  validates! :x, :y,
             numericality: true

  class << self
    def create!(user, message, x, y)
      new(user, message, x, y)
    end
  end

  def initialize(user, message, x, y)
    self.user = user
    self.message = message
    self.x = x
    self.y = y
    valid?
  end

  def render
    {
      name: user.name,
      user_key: user.key,
      key: "#{Time.now.to_i}_#{SecureRandom.hex(2)}_#{user.key}",
      message: message,
      x: x,
      y: y
    }
  end
end