json.suggested_users @besties do |bestie|
  json.partial! "api/v1/shared/user", user: bestie
end