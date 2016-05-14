module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    protected
    def find_user
      User.find_by(uuid: cookies.signed[:uuid]) || reject_unauthorized_connection
    end
  end
end
