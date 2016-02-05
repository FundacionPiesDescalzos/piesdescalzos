class Nutrition < ActiveRecord::Base
  belongs_to :student
	belongs_to :user
  # import CSV
  def self.import(file, school, year, period, user)
		allowed_attributes = ["weight", "height", "identification"]
		   CSV.foreach(file.path, headers: true, :encoding => 'WINDOWS-1252') do |row|
			student = Student.find_by_identification(row["identification"])
			if student.present? && student.school_id = school
				if row["height"].present?
					nutrition = find_by_identification_and_period_and_height(row["identification"],period,row["height"]) || new	
				else row["weight"].present?
					nutrition = find_by_identification_and_period_and_weight(row["identification"],period,row["weight"]) || new
				end
			  nutrition.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
				nutrition.student_id = student.id
				nutrition.user_id = user
				nutrition.period = period
				nutrition.year = year
				nutrition.save!
				p nutrition
			end
		end
  end
end
