class Student < ActiveRecord::Base
  has_one :guardian
	accepts_nested_attributes_for :guardian
  belongs_to :school
	has_many :scores
  
  def the_school
    self.school.present? ? self.school.name : "Sin escuela"
  end
	
  # export CSV
  def self.to_csv(options = {})
    (CSV.generate(options) do |csv|
      csv << column_names
      all.each do |students|
        csv << students.attributes.values_at(*column_names)
      end
    end).encode('WINDOWS-1252', :undef => :replace, :replace => '')
  end
	
	
  # import CSV
  def self.import(file, school)
		allowed_attributes = ["name",	"id_type",	"gender",	"address",	"last_course",	"outschool_years",	"identification",	"born",	"etnic",	"villa",	"born_state",	"displaced",	"residency_state",	"zone"]
    CSV.foreach(file.path, headers: true, :encoding => 'WINDOWS-1252') do |row|
      student = find_by_identification(row["identification"]) || new
      student.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
			student.school_id = school
			student.save!
    end
  end
end
