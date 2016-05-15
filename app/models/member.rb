class Member
  include ActiveModel::Validations

  attr_accessor :user

  validates! :user,
             presence: true

  class << self
    def create!(user)
      member = new(user)
      member.valid?
      member
    end
  end

  def initialize(user)
    self.user = user
  end

  def render
    {
      name: user.name,
      k: user.key
    }
  end
end