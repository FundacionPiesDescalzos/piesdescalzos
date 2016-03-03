json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :the_date, :boss, :active, :program_id
  json.url activity_url(activity, format: :json)
end
