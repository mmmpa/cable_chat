def wait_for(wait = 2, &block)
  start = Time.now.to_i
  store = block.().dup
  loop do
    break if block.() != store
    raise 'timeout' if Time.now.to_i - start > wait
  end
end

def wait_for_matching(wait = 2, &block)
  start = Time.now.to_i
  loop do
    result = block.()
    break result if !!result
    raise 'timeout' if Time.now.to_i - start > wait
  end
end