json.partial! "api/v1/shared/user", user: @user

json.auth_token JsonWebToken.encode(user_id: @user.id)
