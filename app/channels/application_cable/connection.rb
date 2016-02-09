module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      auth_info = JSON.parse(cookies["ember_simple_auth:session"])["authenticated"] || {}
      current_user = User.find_by_uid(auth_info["uid"])

      if current_user && current_user.valid_token?(auth_info["accessToken"] , auth_info["client"])
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
