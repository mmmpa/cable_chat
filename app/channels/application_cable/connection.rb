module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user_or_reject
    end

    def close
      tell_closing
      super
    end

    protected

    def find_user_or_reject
      if user = User.find_by(uuid: cookies.signed[:uuid])
        user
      else
        tell_closing
        reject_unauthorized_connection
      end
    end

    def tell_closing
      transmit_rejection
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
