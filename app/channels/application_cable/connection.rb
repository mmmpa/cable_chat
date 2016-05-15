module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user_or_reject
    end

    def disconnect
      # クリーンアップが必要なら
    end

    protected
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
        identifier: JSON.generate({channel: SessionChannel.to_s}),
        type: ActionCable::INTERNAL[:message_types][:rejection]
      )
    end
  end
end
