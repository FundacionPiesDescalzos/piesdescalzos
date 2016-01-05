json.array!(@attendances) do |attendance|
  json.extract! attendance, :id, :identification, :period, :went_days, :skip_days, :reason, :student_id
  json.url attendance_url(attendance, format: :json)
end
