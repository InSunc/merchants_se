class JwtService

  def self.encode(payload, expiration = 1.hours.from_now)
    payload = payload.dup
    payload['expiration'] = expiration.to_i
    JWT.encode(payload, 'secret')
  end

  def self.decode(token)
    JWT.decode(token, 'secret').first
  end

end
