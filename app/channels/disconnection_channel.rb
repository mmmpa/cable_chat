class DisconnectionChannel < ApplicationCable::Channel
  def subscribed
    stream_from connection.me
  end

  def transmit(data, *rest)
    connection.tell_closing if !!data['disconnection']
  end
end