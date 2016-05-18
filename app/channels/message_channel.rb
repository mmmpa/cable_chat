class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'message'
  end

  def receive(data)
    ActionCable.server.broadcast('message', message(data))
  end

  def message(data)
    {message: MemberMessage.create!(current_user, data['message'], data['x'], data['y']).render}
  end
end