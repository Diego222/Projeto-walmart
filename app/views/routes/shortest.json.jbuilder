if @shortest.nil?
  json.content 'Inexistent path'
else
  json.(@shortest, :path, :cost, :distance)
end