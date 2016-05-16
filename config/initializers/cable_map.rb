module ActionCable
  module SubscriptionAdapter
    class SubscriberMap
      def broadcast(channel, message)
        list = @sync.synchronize do
          return if !@subscribers.key?(channel)
          @subscribers[channel].dup
        end

        list.each do |subscriber|
          invoke_callback(subscriber, message)
        end
      end
    end
  end
end
