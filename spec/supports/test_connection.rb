class TestConnection
  attr_reader :identifiers, :logger, :current_user, :server, :transmissions, :exited

  delegate :pubsub, to: :server

  def initialize(user = User.create!(name: 'abcd'), coder: ActiveSupport::JSON, subscription_adapter: SuccessAdapter)
    @coder = coder
    @identifiers = [ :current_user ]

    @current_user = user
    @logger = ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(StringIO.new)
    @server = TestServer.new(subscription_adapter: subscription_adapter)
    @transmissions = []
  end

  def transmit(cable_message)
    @transmissions << encode(cable_message)
  end

  def decode(websocket_message)
    @coder.decode websocket_message
  end

  def encode(cable_message)
    @coder.encode cable_message
  end

  def exit
    @exited = true
  end
end
