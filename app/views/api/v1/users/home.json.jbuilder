if @suggested_besties.present? || @besties_near_you.present?
  json.besties_near_you @besties_near_you do |bestie|
    json.partial! "api/v1/shared/user", user: bestie
  end

  json.suggested_besties @suggested_besties do |bestie|
    json.partial! "api/v1/shared/user", user: bestie
  end
else
  json.message "No users present"
end