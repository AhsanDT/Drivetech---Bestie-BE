json.users @users do |user|
  json.partial! "api/v1/shared/user", user: user
end