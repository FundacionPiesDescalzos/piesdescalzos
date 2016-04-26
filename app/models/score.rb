class Score < ActiveRecord::Base
  belongs_to :student
	belongs_to :user
  
  
  # export CSV
  def self.to_csv
    attributes = %w{identification period area score year}
    (CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |score|
        # csv << attributes.map{ |attr| user.send(attr) }
        csv << [score.student.identification, score.period, score.area, score.score, score.year]
      end
    end).encode('WINDOWS-1252', :undef => :replace, :replace => '')
  end
  
  # import CSV
  def self.import(file, school, year, period, user)
		allowed_attributes = ["identification", "area", "score", "pass"]
		  CSV.foreach(file.path, headers: true, :encoding => 'WINDOWS-1252') do |row|
			student = Student.find_by_identification(row["identification"])
			if student.present? && student.school_id = school
			  score = find_by_identification_and_period_and_area(row["identification"],period,row["area"]) || new
			  score.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
				score.student_id = student.id
				score.user_id = user
				score.period = period
				score.year = year
				score.save!
				p score
			end
		end
  end
end
