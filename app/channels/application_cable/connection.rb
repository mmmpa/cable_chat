module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    class << self
      attr_accessor :connections

      def enter(connection, user)
        self.connections ||= Hash.new { |h, k| h[k] = [] }
        connections[user.id].push(connection)
      end

      def exit(user)
        connections[user.id].each(&:close)
        connections.delete(user.id)
      end
    end

    def connect
      self.current_user = find_user_or_reject
    end

    def exit
      self.class.exit(current_user)
    end

    def close
      transmit_rejection
      super
    end

    protected
    def find_user_or_reject
      if user = User.find_by(uuid: cookies.signed[:uuid])
        self.class.enter(self, user)
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
