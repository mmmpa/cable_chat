class RoomsController < ApplicationController
  def index
  end

  def members
    ActionCable.server.broadcast('member', {members: User.select(:name, :key).to_a.map(&:as_json)})
    render nothing: true
  end
end
