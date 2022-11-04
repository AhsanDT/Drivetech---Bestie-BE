json.data do
  json.(interest_or_talent) do |record|
    json.id record.id
    json.title record.title
  end
end