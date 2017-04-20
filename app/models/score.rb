class Score < ActiveRecord::Base
  belongs_to :student
	belongs_to :user
  validates :score, :user_id, :area, :year, :student_id, :period, presence: true
  
  
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
		data = CSV.read(file.path, headers: true, :encoding => 'WINDOWS-1252') 

		data.each do |row|
  			student = Student.find_by_identification(row["identification"])
        areas = ["Naturales", "Sociales", "Lenguaje", "Matematicas", "Disciplina"]
        posible = row.to_hash.select { |k,v| areas.include? k }
  			if student.present? && student.try(:school_id).to_i == school.to_i
          scores = where(period: period).joins(:student).merge(Student.where(:identification => row["identification"]))
          if !scores.empty?
            # go trough all of them and compare with posible areas update or create
            scores.each do |score| 
              if areas.include? score.area
                score.area = score.area
                score.score = posible[score.area]
                score.student_id = student.id
                score.user_id = user
                score.period = period
                score.year = year
                score.save!
              end
            end
          else
            posible.each do |k,v|
              if v.present?
                new_score = new
                new_score.area = k 
                new_score.score = v
                new_score.student_id = student.id
                new_score.user_id = user
                new_score.period = period
                new_score.year = year
                new_score.save!
              end 
            end
          end
  			end
  		end
      # "the end"
  end
end
