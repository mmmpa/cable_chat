class SessionsController < ApplicationController
  def create
    user = User.find_by(uuid: cookies.signed[:uuid]) || User.create!(session_params)
    cookies.signed[:uuid] = user.uuid
    head :ok
  rescue ActiveRecord::RecordInvalid => e
    render status: 400, json: {message: e.record.errors.full_messages}
  end

  private

  def session_params
    params.require(:session).permit(:name)
  end
end
