class Nutrition < ActiveRecord::Base
  belongs_to :student
	belongs_to :user
  # import CSV
	
	def imc
		self.weight / (self.height*self.height)
	end
  
  # export CSV
  def self.to_csv
    attributes = %w{identification weight height period year desviacion}
    (CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |nutrition|
        # csv << attributes.map{ |attr| user.send(attr) }
        csv << [nutrition.student.identification, nutrition.weight, nutrition.height, nutrition.period, nutrition.year, nutrition.desviacion]
      end
    end).encode('WINDOWS-1252', :undef => :replace, :replace => '')
  end
	
  def self.import(file, school, year, period, user)
		allowed_attributes = ["weight", "height", "identification", "desviacion"]
		   CSV.foreach(file.path, headers: true, :encoding => 'WINDOWS-1252') do |row|
			student = Student.find_by_identification(row["identification"])
			if student.present? && student.school_id = school
				if row["height"].present?
					nutrition = find_by_identification_and_period_and_height(row["identification"],period,row["height"]) || new	
        elsif row["weight"].present?
					nutrition = find_by_identification_and_period_and_weight(row["identification"],period,row["weight"]) || new
				else row["desviacion"].present?
					nutrition = find_by_identification_and_period_and_desviacion(row["identification"],period,row["desviacion"]) || new
				end
			  nutrition.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
				nutrition.student_id = student.id
				nutrition.user_id = user
				nutrition.period = period
				nutrition.year = year
				nutrition.save!
			end
		end
  end
end
