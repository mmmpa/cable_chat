class UserConnections
  def initialize
    @mutex = Monitor.new
    @pool = nil
  end

  def add(connection)
    @mutex.synchronize do
      key = pick_key(connection)
      pool[key].push(connection)
    end
  end

  def remove(connection)
    @mutex.synchronize do
      key = pick_key(connection)
      pool[key].delete(connection)
      pool.delete(key) if pool[key].size == 0
    end
  end

  def all(connection, &block)
    @mutex.synchronize do
      key = pick_key(connection)
      pool[key].each do |pooled|
        pooled.instance_eval(&block)
      end
    end
  end

  def adapter_for(connection)
    Adapter.new(self, connection)
  end

  private

  def pick_key(connection)
    connection.current_user.id
  end

  def pool
    @pool || @mutex.synchronize { @pool ||= Hash.new { |h, k| h[k] = [] } }
  end

  class Adapter
    def initialize(connections, connection)
      @connections, @connection = connections, connection
    end

    def add
      @connections.add(@connection)
    end

    def remove
      @connections.remove(@connection)
    end

    def all(&block)
      @connections.all(@connection, &block)
    end
  end
end