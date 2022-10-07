json.data do
  json.(@interest) do |interest|
    json.id interest.id
    json.title interest.title
  end
end
