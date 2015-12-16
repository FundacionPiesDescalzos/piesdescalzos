json.array!(@students) do |student|
  json.extract! student, :id, :name, :id_type, :gender, :address, :last_course, :outschool_years, :identification, :born, :etnic, :villa, :born_state, :displaced, :residency_state, :zone, :guardian_id
  json.url student_url(student, format: :json)
end
