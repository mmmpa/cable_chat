module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user_or_reject
      create_disconnection
    end

    def me
      internal_channel
    end

    def tell_closing
      transmit_rejection
    end

    def close
      tell_closing
      super
    end

    def exit
      # 閉鎖通知と閉鎖命令
      ActionCable.server.broadcast internal_channel, {disconnection: true}
      ActionCable.server.disconnect({current_user: current_user})
      # 自分を閉鎖
      close
    end

    protected
    def create_disconnection
      send_async(:dispatch_websocket_message, dummy_command)
    end

    def dummy_command
      {
        command: 'subscribe',
        identifier: {channel: DisconnectionChannel.to_s}.to_json,
      }.to_json
    end

    def find_user_or_reject
      if user = User.find_by(uuid: cookies.signed[:uuid])
        user
      else
        transmit_rejection
        reject_unauthorized_connection
      end
    end

    def transmit_rejection
      # SessionChannelのメッセージとして送信
      transmit(
        identifier: {channel: SessionChannel.to_s}.to_json,
        type: ActionCable::INTERNAL[:message_types][:rejection]
      )
    end
  end
end
