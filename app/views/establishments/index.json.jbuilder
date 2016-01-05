json.array!(@establishments) do |establishment|
  json.extract! establishment, :id, :code, :name, :department, :state, :phone, :email
  json.url establishment_url(establishment, format: :json)
end
