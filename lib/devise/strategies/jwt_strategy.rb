module Devise
    module Strategies
        class JwtStrategy < Authenticatable

            def valid?
                !request.headers['Authorization'].nil?
            end

            def authenticate!
                payload = JwtService.decode(token)
                puts payload['email'].to_s
                user = User.find_by_email(payload['email'])
                success! user
            rescue ::JWT::ExpiredSignature
                fail! 'Token expired'
            rescue ::JWT::DecodeError
                fail! 'Invalid token'
            rescue
                fail!
            end

            private
            def token
                request.headers['Authorization'].split(' ').last
            end
        end
    end
end