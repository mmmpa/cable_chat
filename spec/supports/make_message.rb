def make_message(channel, data)
  {command: 'message', identifier: {channel: channel.to_s}.to_json, data: data.to_json}.to_json
end

def make_subscribe(channel)
  {command: 'subscribe', identifier: {channel: channel.to_s}.to_json}.to_json
end

def make_perform(channel, perform)
  {command: 'message', identifier: {channel: channel.to_s}.to_json, data: {action: perform}.to_json}.to_json
end
