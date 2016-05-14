class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat'
    current_user.subscribed
    transmit(me: Member.create!(current_user).render)
  end

  def unsubscribed
    current_user.unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast('chat', message(data))
  end

  def exit
    current_user.destroy!
    close
  end

  def message(data)
    {message: MemberMessage.create!(current_user, data['message'], data['x'], data['y']).render}
  end
end