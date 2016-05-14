class MemberChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'member'
    broadcast_members
  end

  def unsubscribed
  end

  def broadcast_members
    ActionCable.server.broadcast('member', members)
  end

  def members
    {members: User.all.map { |user| Member.create!(user).render }}
  end
end