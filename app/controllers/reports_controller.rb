class ReportsController < ApplicationController
	def index
	@hola = "hola"
	# @students = Student.created_before(Time.now)
	@boys = 0
	@girls = 0
	#@students = Student.dynamic("Antioquia",1..6,1..11)
	
	if params[:course].present? && params[:course][:course_number].present?
		@courses = params[:course][:course_number]
	else
		@courses = []
	end

	if params[:establishments].present? && params[:establishments][:establishment_id].present?
		@sch = School.where(establishment_id:params[:establishments][:establishment_id])
		if @sch.present?
			@ids = []
			@sch.each do |sch|
				@ids.push(sch.id)
			end
		end
		
		if @ids.present?
			@schools = @ids
		else
			@schools = []
		end
		
	end
	
	
	
	if params[:departments].present? && params[:departments][:cities].present?
		@residency = GeneralInfo.cities[:"#{params[:departments][:cities]}"]
	else
		@residency = []
	end
	
	
	if @residency.present? && @courses.present? && @schools.present?
		@students = Student.where(last_course: @courses, residency_state: @residency, school_id: @schools)
	elsif !@residency.present? && @courses.present? && @schools.present?
		@students = Student.where(last_course: @courses, school_id: @schools)
	elsif @residency.present? && !@courses.present? && @schools.present?
		@students = Student.where(residency_state: @residency, school_id: @schools)
	elsif @residency.present? && @courses.present? && !@schools.present?
		@students = Student.where(residency_state: @residency, last_course: @courses)
	elsif @residency.present? && !@courses.present? && !@schools.present?
		@students = Student.where(residency_state: @residency)
	elsif !@residency.present? && @courses.present? && !@schools.present?
		@students = Student.where(last_course: @courses)
	elsif !@residency.present? && !@courses.present? && @schools.present?
		@students = Student.where(school_id: @schools)
	else
		@students = Student.all
	end
	
	@under8 = 0
	@pluls12 = 0
	@middle = 0
	@displaced = 0
	@all = @students.count
	@hash_etnic = {}
	
	@students.each do |student|
		# gender
		if student.gender == "masculino"
			@boys += 1 
		else student.gender == "femenino"
			@girls += 1 
		end
		
		if student.age < 8
			@under8 += 1
		elsif student.age >= 8 && student.age <= 12
			@middle += 1  
		elsif student.age > 12
			@pluls12 += 1
		end
	
	  if student.displaced == true || student.displaced == "t"
			@displaced += 1 
		end
		@less = @all - @displaced
		
		if @hash_etnic.key?(student.etnic)
			@hash_etnic[student.etnic]+= 1
		else
			@hash_etnic[student.etnic] = 0 
		end
		
	end

	@finish_etnias = {
    name: 'Etnias',
    colorByPoint: true,
		data: []
	}
	
	@hash_etnic.each do |key, etnics|
		@finish_etnias[:data].push({name: key, y: etnics});
	end
	
	
	end
	
end