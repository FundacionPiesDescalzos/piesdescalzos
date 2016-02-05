json.array!(@nutritions) do |nutrition|
  json.extract! nutrition, :id, :weight, :height, :identification, :student_id
  json.url nutrition_url(nutrition, format: :json)
end
