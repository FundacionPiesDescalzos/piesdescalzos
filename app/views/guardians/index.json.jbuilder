json.array!(@guardians) do |guardian|
  json.extract! guardian, :id, :id_type, :identification, :name, :last_name, :second_name, :gender, :born, :address, :villa, :zone, :department, :municipality, :phone, :cel, :email, :relationship
  json.url guardian_url(guardian, format: :json)
end
