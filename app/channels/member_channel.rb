class MemberChannel < ApplicationCable::Channel
  def subscribed
    current_user.subscribed
  end

  def unsubscribed
    current_user.unsubscribed
    members
  end

  def broadcast_members
    ActionCable.server.broadcast('chat', members)
  end

  def members
    {members: User.select(:name, :key).to_a.map(&:as_json)}
  end
end