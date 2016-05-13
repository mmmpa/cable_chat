class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat'

    current_user.subscribed
    broadcast_members
  end

  def unsubscribed
    current_user.unsubscribed
    broadcast_members
  end

  def broadcast_members
    ActionCable.server.broadcast('chat', members)
  end

  def receive(data)
    ActionCable.server.broadcast('chat', message(data))
  end

  def members
    {members: User.select(:name, :key).to_a.map(&:as_json)}
  end

  def message(data)
    {message: {name: current_user.name, key: "#{Time.now.to_i}_#{current_user.key}", message: data['message']}}
  end
end