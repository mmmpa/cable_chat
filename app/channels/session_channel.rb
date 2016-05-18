class SessionChannel < ApplicationCable::Channel
  def subscribed
    transmit(me: Member.create!(current_user).render)
    current_user.subscribed
  end

  def unsubscribed
    current_user.unsubscribed
  end

  def exit
    current_user.exit!
    connection.exit
  end
end