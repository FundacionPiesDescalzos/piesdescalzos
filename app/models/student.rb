class Student < ActiveRecord::Base
  has_one :guardian
	has_one :health_care
	accepts_nested_attributes_for :guardian
  belongs_to :school
	has_many :scores
	has_and_belongs_to_many :activities
	has_many :nutritions
	
	mount_uploader :pic, PicUploader
	
	def self.genderize(g)
	   joins(:nutritions, :school).where("students.gender = :gen AND schools.created_at <= :end_date", {gen: g, end_date: Time.now.midnight}) if g.present?
	end
	
	def self.dynamic(r,d,c)
		if r.present? && d.present? && c.present?
	    joins(:nutritions, :school).where("students.residency_state = :res AND students.school_id = :school_id AND students.last_course = :course", {res: r, school_id: d, course: c})
		end
	end
	
	def self.created_before(time)
	    joins(:nutritions, :school).where("schools.created_at < ?", time) if time.present?
	 end
  
  def the_school
    self.school.present? ? self.school.name : "Sin escuela"
  end
	
	def age
		now = Time.now.utc.to_date
		now.year - self.born.year - (self.born.to_date.change(:year => now.year) > now ? 1 : 0)
	end
	
	def average
		@i = 0;
		@mas = 0;
    self.scores.each do |score| 
	     if score.year.to_i == Time.now.year || score.year.to_i == Time.now.year-1 
				 @i = @i + 1
			   @mas = @mas+score.score.to_f 
			  end 
     end
		@mas = @mas/@i unless @i == 0 
		return @mas
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
		# allowed_attributes = ["name",	"id_type",	"gender",	"address",	"last_course",	"outschool_years",	"identification",	"born",	"etnic",	"villa",	"born_state",	"displaced",	"residency_state",	"zone"]
		school = School.find(school)
		import = ImportUserCSV.new(file: file) do
		  model school.students
		end
		p import.valid_header? # => false
		import.run!
		p import.report.status # => :aborted
		return import.report # => "The following columns are required: "email""
		
			#     CSV.foreach(file.path, headers: true, :encoding => 'WINDOWS-1252') do |row|
			#       student = find_by_identification(row["identification"]) || new
			#       student.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
			# student.school_id = school
			# student.save!
			#     end
  end
end

class ImportUserCSV
  include CSVImporter

  model Student
	column :email, as: [/e.?mail/i, "Correo"], to: ->(email) { email.downcase }
	column :name, as: ["Nombre"], to: ->(name) { name.downcase }
	column :id_type, as: ["Tipo de identificacion"]
	column :gender, as: ["Genero"]
	column :address, as: ["Direccion", /Direcci(ó|o)n/i ]
	column :last_course, as: ["Ultimo curso"]
	column :outschool_years, as: ["desescolarizado"]
	column :identification, as: ["Identification"]
	column :born, as: ["Nacimiento"]
	column :etnic, as: ["Etnia"]
	column :villa, as: ["Barrio"]
	column :born_state, as: ["Nacido en", "Ciudad de nacimiento"]
	column :displaced, as: ["Desplazado"]
	column :residency_state, as: ["Lugar de residencia"]
	column :zone, as: ["Estrato"]
	identifier :identification
end