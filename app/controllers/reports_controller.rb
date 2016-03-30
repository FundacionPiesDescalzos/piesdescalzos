class ReportsController < ApplicationController
	def index
	@hola = "hola"
	# @students = Student.created_before(Time.now)
	@boys = 0
	@girls = 0
	#@students = Student.dynamic("Antioquia",1..6,1..11)
	@co = 1..11
	@co = @co.map { |i| i.to_s }
	if params[:course].present? && params[:course][:course_number]
		@courses = params[:course][:course_number]
	else
		@courses = @co
	end
	

	if params[:establishments].present? && params[:establishments][:establishment_id]
		@sch = School.where(establishment_id:params[:establishments][:establishment_id])
		if @sch.present?
			@ids = []
			@sch.each do |sch|
				@ids.push(sch.id)
			end
		end
	end
	
	if @ids.present?
		@schools = @ids
	else
		@schools = 1..Establishment.all.count.to_int
	end
	@residency = []
	if params[:departments].present? && params[:departments][:cities]
		@residency = GeneralInfo.cities[:"#{params[:departments][:cities]}"]
		p @residency
	end
	if @residency.present?
		@students = Student.joins(:nutritions, :school).where(last_course: @courses, residency_state: @residency, school_id: @schools)
	else
		@students = Student.joins(:nutritions, :school).where(last_course: @courses, school_id: @schools)
	end
	
	@students.each do |student|
		if student.gender == "masculino"
			@boys = @boys + 1 
		else
			@girls = @girls + 1 
		end
	end
	
	end
	
end