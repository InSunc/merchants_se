require 'logger'

module Devise
    module Strategies
        class TokenGenStrategy < Authenticatable

            def valid?
                request.content_type == "application/json"
            end

            def authenticate!
                request_body = JSON.parse(request.body.read)
                email = request_body['email']
                password = request_body['password']
                Rails.logger.debug "\temail: #{email}, password: #{password}"

                user = User.find_by_email(email)

                Rails.logger.debug "User found: #{!user.nil?} #{user.email}"

                if user.valid_password?(password)
                    Rails.logger.debug "Auth passed"
                    token = JwtService.encode(:email => email)
                    success!(token)
                else
                    Rails.logger.debug "Wrong password"
                    fail! "Invalid credentials"
                end
            end
        end
    end
end