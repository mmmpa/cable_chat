class SessionChannel < ApplicationCable::Channel
  def subscribed
    current_user.subscribed
    transmit(me: Member.create!(current_user).render)
  end

  def unsubscribed
    current_user.unsubscribed
  end

  def exit
    current_user.destroy!
    transmit(exit: true)
    connection.close
  end
end