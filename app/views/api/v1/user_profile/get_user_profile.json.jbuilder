json.partial! "api/v1/shared/user", user: @user
json.posts @user.posts
json.reviews @user.reviews