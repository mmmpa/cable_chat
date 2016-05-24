class SessionChannel < ApplicationCable::Channel
  class << self
    def user_connections
      @user_connections ||= UserConnections.new
    end
  end

  user_connections

  def subscribed
    user_connections.add
    transmit(me: Member.create!(current_user).render)
    current_user.subscribed
  end

  def unsubscribed
    user_connections.remove
    current_user.unsubscribed
  end

  def exit
    current_user.exit!
    user_connections.all { close }
  end

  private

  def user_connections
    @adapter ||= self.class.user_connections.adapter_for(self.connection)
  end
end