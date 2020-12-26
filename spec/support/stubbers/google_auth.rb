class AuthStubber
  attr_reader :token, :reauth_token, :counter

  def initialize(token, reauth_token)
    @token = token
    @reauth_token = reauth_token
    @counter = 0
  end

  def apply!(hash)
    @counter = counter + 1

    if counter == 1
      hash['Authorization'] = "Bearer #{token}"
    else
      hash['Authorization'] = "Bearer #{reauth_token}"
    end
  end

  def reset_counter
    @counter = 0
  end
end
