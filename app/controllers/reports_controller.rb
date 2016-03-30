class ReportsController < ApplicationController
	def index
	@hola = "hola"
	# @students = Student.created_before(Time.now)
	@boys = Student.genderize("masculino")
	@girls = Student.genderize("femenino")
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
	
	if params[:departments].present? && params[:departments][:cities]
		@residency = [params[:departments][:cities]]
	end
	
	if @residency
		@students = Student.joins(:nutritions, :school).where(last_course: @courses, residency_state: @residency, school_id: @schools)
	else
		@students = Student.joins(:nutritions, :school).where(last_course: @courses, school_id: @schools)
	end
	
	end
	
end