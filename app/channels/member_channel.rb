class MemberChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'member'
  end

  def unsubscribed
    broadcast_members
  end

  def hello
    broadcast_members
  end

  def broadcast_members
    ActionCable.server.broadcast('member', members)
  end

  def members
    {members: User.in.map { |user| Member.create!(user).render }}
  end
end