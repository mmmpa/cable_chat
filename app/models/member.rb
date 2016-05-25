class Member
  include ActiveModel::Validations

  attr_accessor :user

  validates! :user,
             presence: true

  class << self
    def create!(user)
      new(user)
    end
  end

  def initialize(user)
    self.user = user
    valid?
  end

  def render
    {
      name: user.name,
      key: user.key
    }
  end
end