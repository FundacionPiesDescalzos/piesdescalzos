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
      areas = ["matematicas", "ingles", "historia", "Educacion fisica"]
      posible = row.to_hash.select { |k,v| areas.include? k }
      p "posible"
      p posible
			if student.present? && student.school_id = school
        scores = where(period: period).joins(:student).merge(Student.where(:identification => row["identification"]))
        if !scores.empty?
          # go trough all of them and compare with posible areas update or create
          scores.each do |score| 
            p "score.area"
            p score.area.gsub(/[^\x00-\x7F]/n,'').downcase.to_s
            if areas.include? score.area.gsub(/[^\x00-\x7F]/n,'').downcase.to_s
              p "new score"
              p posible[score.area]
              # score.score = posible[score.area]
              # score.save!
            end
          end
        else
          p "create them"
        end
			  # score.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
        # score.student_id = student.id
        # score.user_id = user
        # score.period = period
        # score.year = year
        # score.save!
			end
		end
    p "the end"
  end
end
