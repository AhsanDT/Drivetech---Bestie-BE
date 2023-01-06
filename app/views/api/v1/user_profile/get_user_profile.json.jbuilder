json.partial! "api/v1/shared/user", user: @user
json.posts @user.posts
json.reviews @user.reviews
json.reviews_average_rating @review_average_rating