class SocialLoginService
  require 'net/http'
  require 'net/https'
  require 'open-uri'

  PASSWORD_DIGEST = SecureRandom.hex(10)
  APPLE_PEM_URL = 'https://appleid.apple.com/auth/keys'

  def initialize(provider, token, type)
    @token = token
    @provider = provider.downcase
    @type = type
  end

  def social_logins
    if @provider == 'google'
      google_signup(@token)
    elsif @provider == 'facebook'
      facebook_signup(@token)
    elsif @provider == 'apple'
      apple_signup(@token)
    end
  end

  def google_signup(token)
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}")
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body) if response.code != '200'
    json_response = JSON.parse(response.body)
    user = create_user(json_response['email'], json_response['sub'], json_response, json_response['name'], json_response['picture'])
    token = JsonWebToken.encode(user_id: user.id)
    image_url = Rails.application.routes.url_helpers.url_for(user.profile_image) rescue nil
    [user, token, image_url]
  end

  def facebook_signup(token)
    uri = URI("https://graph.facebook.com/v13.0/me?fields=name,email&access_token=#{token}")
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body) if response.code != '200'
    json_response = JSON.parse(response.body)
    user = create_user(json_response['email'], json_response['sub'], json_response , json_response['name'], json_response['picture'])
    token =JsonWebToken.encode(user_id: user.id)
    image_url = Rails.application.routes.url_helpers.url_for(user.profile_image) rescue nil
    [user, token, image_url]
  end

  def apple_signup(token)
    jwt = token
    begin
      header_segment = JSON.parse(Base64.decode64(jwt.split(".").first))
      alg = header_segment["alg"]
      kid = header_segment["kid"]
      apple_response = Net::HTTP.get(URI.parse(APPLE_PEM_URL))
      apple_certificate = JSON.parse(apple_response)
      keyHash = ActiveSupport::HashWithIndifferentAccess.new(apple_certificate["keys"].select { |key| key["kid"] == kid }[0])
      jwk = JWT::JWK.import(keyHash)
      token_data = JWT.decode(jwt, jwk.public_key, true, { algorithm: alg })[0]
    rescue StandardError => e
      return e.as_json
    end

    data = token_data.with_indifferent_access
    user = create_user(data['email'], data['sub'], data, data['name'], nil)
    token_apple = WJsonWebToken.encode(user_id: user.id)
    [user, token_apple]
  end

  private

  def create_user(email, provider_id, response, name, profile_image)
    if (user = User.find_by(email: email))
      user
    elsif @provider == "apple"
      user = User.create(email: response['email'], password: PASSWORD_DIGEST, profile_type: @type)
    else
      user = User.create(email: response['email'], first_name: response['name'].split(' ').first, last_name: response['name'].split(' ').last,  password: PASSWORD_DIGEST, login_type: 'social login', profile_type: @type)
      if profile_image.present?
        download = URI.open(profile_image)
        filename = "profile-#{user.id}-picture"
        user.profile_image.attach(io: download, filename: filename, content_type: download.content_type)
      end
    end

    user
  end
end
