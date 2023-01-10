json.partial! "api/v1/shared/user", user: @user
json.review_average_rating @review_average_rating

json.auth_token JsonWebToken.encode(user_id: @user.id)
