json.portfolio(@current_user.portfolio) do |portfolio|
  json.portfolio_url portfolio.present? ? portfolio.blob.url : ''
end