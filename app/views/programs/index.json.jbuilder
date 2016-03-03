json.array!(@programs) do |program|
  json.extract! program, :id, :name, :line, :city, :description, :active
  json.url program_url(program, format: :json)
end
