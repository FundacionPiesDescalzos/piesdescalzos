json.array!(@homes) do |home|
  json.extract! home, :id, :name, :paragraph, :email, :pictures, :texto
  json.url home_url(home, format: :json)
end
