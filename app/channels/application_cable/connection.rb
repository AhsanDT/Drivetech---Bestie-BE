module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      begin
        if request.params[:token].present?
            @jwt_token = request.params[:token]
             self.current_user = find_verified_user
        else
          self.current_user = find_verified_admin
        end
      rescue
        puts "connection is not created"
      end
    end

    private
    attr_reader :jwt_token
    def find_verified_user
      payload = decode_token
      User.find_by_email(payload["email"])
    end

    def find_verified_admin
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
    def decode_token
      JsonWebToken.decode(jwt_token.to_s)
    end
  end
end
