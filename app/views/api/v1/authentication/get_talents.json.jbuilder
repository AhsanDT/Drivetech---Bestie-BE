json.data do
  json.(@talent) do |talent|
    json.id talent.id
    json.title talent.title
  end
end
