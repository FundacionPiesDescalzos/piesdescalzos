json.array!(@schools) do |school|
  json.extract! school, :id, :code, :name, :address, :neighborhood, :zone, :contact_name, :contact_position, :phone, :email, :headquarter, :foundation_present, :establishment_id
  json.url school_url(school, format: :json)
end
