json.array!(@scores) do |score|
  json.extract! score, :id, :identification, :period, :area, :score, :student_id
  json.url score_url(score, format: :json)
end
