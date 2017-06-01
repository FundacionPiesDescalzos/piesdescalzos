class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	
	helper_method :alertas
	
	def alertas
		@people = []
		@students = Student.all
		@students.includes(:nutritions).find_each do |student|
			if student.nutritions.present?
				@imc = student.nutritions.last.imc
				unless @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_min"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_max"]
					@people.push(student)
				end
			end
		end
		@people
	end
	
end
