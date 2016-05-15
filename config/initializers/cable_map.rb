module ActionCable
  module SubscriptionAdapter
    class SubscriberMap
      def remove_subscriber(channel, subscriber)
        @sync.synchronize do
          @subscribers[channel].delete(subscriber)

          p [:remove_subscriber, channel,  @subscribers]
          if @subscribers[channel].empty?
            @subscribers.delete channel
            remove_channel channel
          end
          p [:remove_subscriber_after, channel, @subscribers]
        end
      end

      def broadcast(channel, message)
        p [:broadcast, @subscribers]
        list = @sync.synchronize do
          #return if !@subscribers.key?(channel)
          @subscribers[channel].dup
        end

        list.each do |subscriber|
          invoke_callback(subscriber, message)
        end
      end
    end
  end
end
