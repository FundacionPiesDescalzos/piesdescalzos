class ReportsController < ApplicationController
	def index
	@hola = "hola"
	# @students = Student.created_before(Time.now)
	@boys = Student.genderize("masculino")
	@girls = Student.genderize("femenino")
	p params
	end
	
end