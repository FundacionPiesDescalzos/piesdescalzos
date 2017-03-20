class Student < ActiveRecord::Base
  has_one :guardian, dependent: :destroy
	has_one :health_care, dependent: :destroy
	accepts_nested_attributes_for :guardian
  belongs_to :school
	has_many :scores, dependent: :destroy
	has_many :activities, through: :assistances
	has_many :nutritions, dependent: :destroy
	has_many :assistances, dependent: :destroy
	
	mount_uploader :pic, PicUploader
  
  validates :name, :gender, :last_course, :identification, presence: true
  validates :last_course, numericality: { only_integer: true, less_than: 12 }
  validates :identification, numericality: { only_integer: true, less_than: 1500000000 }
  validates :id_type, inclusion: {in: %w(TI RC NUIP Otro)}
	
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
	
	def average
		adding = 0
		self.scores.each do |score| 
			adding += 1
			total += score.to_f
		end
		total = total/(adding > 0 ? adding : 1)
	end
	
	def touchdown
		self.average > 3.0 ? true : false
	end
	
  # def age
  #   now = Time.now.utc.to_date
  #   now.year - self.born.year - (self.born.to_date.change(:year => now.year) > now ? 1 : 0)
  # end
  
  def age
    now = Time.now.utc.to_date
    now.year - self.born.year - ((now.month > self.born.month || (now.month == self.born.month && now.day >= self.born.day)) ? 0 : 1)
  end
	
	def age_month
		now = Time.now.utc.to_date

    if now.month == self.born.month
      if now.day >= self.born.day then 0 else 11 end 
    elsif now.month > self.born.month
      now.month - self.born.month
    elsif now.month < self.born.month
      12 - (self.born.month - now.month)
    end
    
	end
	
	def age_medium
		if age_month >= 6
			math = 5
		else
			math = 0
		end
		response = ("#{age}.#{math}").to_f
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
	
	def lost_year
		@response = true
		 self.scores.each do |score|
			 if score.period.to_i == 5 && score.pass == true 
				 p score.period.to_i
				 p score.pass
				 @response = true
			 else
				 @response = false
			 end
		 end
		 @response
	end
  
  def self.to_csv
    attributes = ["Identificacion", "Nombre", "Tipo de identificacion", "Genero", "Direccion", "Ultimo curso", "desescolarizado", "Nacimiento", "Etnia", "Barrio", "Nacido en", "Desplazado", "Retiro", "Graduado", "Lugar de residencia", "Estrato"]
    (CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |student|
        # csv << attributes.map{ |attr| user.send(attr) }
         csv << [student.identification, student.name, student.id_type, student.gender, student.address, student.last_course, student.outschool_years, student.born, student.etnic, student.villa, student.born_state, student.displaced, student.drop, student.graduated, student.residency_state, student.zone]
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
		import.valid_header? # => false
		import.run!
		import.report.status # => :aborted
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
	column :gender, as: ["Genero"], to: ->(gender) { gender.downcase }
	column :address, as: ["Direccion", /Direcci(ó|o)n/i ]
	column :last_course, as: ["Ultimo curso"]
	column :outschool_years, as: ["desescolarizado"]
	column :identification, as: ["Identificacion"]
	column :born, as: ["Nacimiento"]
	column :etnic, as: ["Etnia"]
	column :villa, as: ["Barrio"]
	column :born_state, as: ["Nacido en", "Ciudad de nacimiento"]
	column :displaced, as: ["Desplazado"]
	column :graduated, as: ["Graduado"]
	column :drop, as: ["Retiro", "Abandono"]
	column :residency_state, as: ["Lugar de residencia"]
	column :zone, as: ["Estrato"]
	identifier :identification
end
