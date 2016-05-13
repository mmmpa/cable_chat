class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"
  end

  def receive(data)
    ActionCable.server.broadcast "chat_#{params[:room]}", {name: current_user.name, message: data['message']}
  end
end