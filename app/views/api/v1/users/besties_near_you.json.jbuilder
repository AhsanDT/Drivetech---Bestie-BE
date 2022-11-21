json.besties_near_you @besties do |bestie|
  json.partial! "api/v1/shared/user", user: bestie
end