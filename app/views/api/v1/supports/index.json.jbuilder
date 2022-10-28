json.data do
  json.(@support) do |support|
    json.support support
    json.support_image support.image.attached? ? support.image.blob.url : ''
  end
end
