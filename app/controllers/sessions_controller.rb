class SessionsController < ApplicationController
  def create
    user = User.create!(session_params)
    cookies.signed[:uuid] = user.uuid

    render nothing: true, status: 201
  end

  private

  def session_params
    params.require(:session).permit(:name)
  end
end
