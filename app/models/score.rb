class Score < ActiveRecord::Base
  belongs_to :student
	
  # import CSV
  def self.import(file, school)
		allowed_attributes = ["identification", "period", "area", "score"]
    CSV.foreach(file.path, headers: true, :encoding => 'WINDOWS-1252') do |row|
			student = Student.find_by_identification(row["identification"])
			if student.present?
	      score = find_by_identification_and_period_and_area(row["identification"],row["period"],row["area"]) || new
	      score.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
				score.student_id = student.id
				score.save!
				p score
			end
    end
  end
end
