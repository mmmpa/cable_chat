class User < ApplicationRecord
  acts_as_authentic do |config|
    config.login_field = :login
    config.require_password_confirmation = false
  end

  def appear(**options)
    pp options
  end

  def disappear

  end

  def away

  end
end
