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
	@disability = 0
	@drop = 0
	@graduated = 0
	@all = @students.count
	@hash_etnic = {}
	@overallscore = {} 
	
  @results = {
  "Delgadez" => {data: 0, girls: 0, boys: 0},
	"Riesgo de delgadez" => {data: 0, girls: 0, boys: 0},
	"Adecuado para la edad" => {data: 0, girls: 0, boys: 0},
	"Sobrepeso" => {data: 0, girls: 0, boys: 0},
	"Obesidad" => {data: 0, girls: 0, boys: 0}
 }
	
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
		elsif student.disability == true || student.disability == "t"
			@disability += 1
		elsif student.drop == true || student.drop == "t"
			@drop += 1
		elsif student.graduated == true || student.graduated == "t"
			@graduated += 1
		end
		
		
		#nutrition 
	  if student.nutritions.present? 
	    @cuantos = student.nutritions.count - 1 
			@imc = student.nutritions[@cuantos].imc
			if @imc < GeneralInfo.nutrition_points[student.gender]["lower"]
				 @results["Delgadez"][:data] = @results["Delgadez"][:data] + 1
				 if student.gender == "femenino"
					 @results["Delgadez"][:girls] = @results["Delgadez"][:girls] + 1
				 else
					 @results["Delgadez"][:boys] = @results["Delgadez"][:boys] + 1
				 end
			elsif @imc > GeneralInfo.nutrition_points[student.gender]["lower"] && @imc < GeneralInfo.nutrition_points[student.gender]["minimum"]
				@results["Riesgo de delgadez"][:data] = @results["Riesgo de delgadez"][:data] + 1
				 if student.gender == "femenino"
					 @results["Riesgo de delgadez"][:girls] = @results["Riesgo de delgadez"][:girls] + 1
				 else
					 @results["Riesgo de delgadez"][:boys] = @results["Riesgo de delgadez"][:boys] + 1
				 end
			elsif @imc > GeneralInfo.nutrition_points[student.gender]["minimum"] && @imc < GeneralInfo.nutrition_points[student.gender]["medium_min"] 
				@results["Adecuado para la edad"][:data] = @results["Adecuado para la edad"][:data] + 1 
			 if student.gender == "femenino"
				 @results["Adecuado para la edad"][:girls] = @results["Adecuado para la edad"][:girls] + 1
			 else
				 @results["Adecuado para la edad"][:boys] = @results["Adecuado para la edad"][:boys] + 1
			 end
			elsif @imc > GeneralInfo.nutrition_points[student.gender]["medium_min"] && @imc < GeneralInfo.nutrition_points[student.gender]["medium_max"] 
				@results["Sobrepeso"][:data] = @results["Sobrepeso"][:data] + 1 
 			 if student.gender == "femenino"
 				 @results["Sobrepeso"][:girls] = @results["Sobrepeso"][:girls] + 1
 			 else
 				 @results["Sobrepeso"][:boys] = @results["Sobrepeso"][:boys] + 1
 			 end
			elsif @imc > GeneralInfo.nutrition_points[student.gender]["maximum"]
				@results["Obesidad"][:data] = @results["Obesidad"][:data] + 1 
  			 if student.gender == "femenino"
  				 @results["Obesidad"][:girls] = @results["Obesidad"][:girls] + 1
  			 else
  				 @results["Obesidad"][:boys] = @results["Obesidad"][:boys] + 1
  			 end
			end 
		end
		
		#/ Nutrition
		
		
		@less = @all - @displaced
		
		if @hash_etnic.key?(student.etnic)
			@hash_etnic[student.etnic]+= 1
		else
			@hash_etnic[student.etnic] = 0 
		end
  		@sc = 0.0 
			@ps = []
			student.scores.each do |score|
				if @overallscore.key?(score.period)
					@sc+=score.score.to_f
					@ps.push(score.area)
					@overallscore[score.period] = {area: score.area, score: @sc, all: @ps}
				else
					@overallscore[score.period] = {area: score.area, score: 0.0, all: []}
				end
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
	
	p "overall"
	p @overallscore	 
	
	end
	
end