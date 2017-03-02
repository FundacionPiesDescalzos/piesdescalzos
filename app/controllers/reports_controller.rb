class ReportsController < ApplicationController
  def index
    #Commenting all @cuantos because is useless
    @hola = "hola"
    # @students = Student.created_before(Time.now)
    @boys = 0
    @girls = 0
    #@students = Student.dynamic("Antioquia",1..6,1..11)
    @establishments = Establishment.all.collect {|p| [ p.name, p.id ] }
    if params[:course].present? && params[:course][:course_number].present?
      @courses = params[:course][:course_number]
    else
      @courses = []
    end

    if params[:establishments].present? && params[:establishments][:establishment_id].present?
      @sch = School.where(establishment_id: params[:establishments][:establishment_id])
      @ids = School.where(establishment_id: params[:establishments][:establishment_id]).pluck(:id)

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
      @students = Student.includes(:activities, :nutritions, :scores, :school).where(last_course: @courses, residency_state: @residency, school_id: @schools)
    elsif !@residency.present? && @courses.present? && @schools.present?
      @students = Student.includes(:activities, :nutritions, :scores, :school).where(last_course: @courses, school_id: @schools)
    elsif @residency.present? && !@courses.present? && @schools.present?
      @students = Student.includes(:activities, :nutritions, :scores, :school).where(residency_state: @residency, school_id: @schools)
    elsif @residency.present? && @courses.present? && !@schools.present?
      @students = Student.includes(:activities, :nutritions, :scores, :school).where(residency_state: @residency, last_course: @courses)
    elsif @residency.present? && !@courses.present? && !@schools.present?
      @students = Student.includes(:activities, :nutritions, :scores, :school).where(residency_state: @residency)
    elsif !@residency.present? && @courses.present? && !@schools.present?
      @students = Student.includes(:activities, :nutritions, :scores, :school).where(last_course: @courses)
    elsif !@residency.present? && !@courses.present? && @schools.present?
      @students = Student.includes(:activities, :nutritions, :scores, :school).where(school_id: @schools)
    else
      @students = Student.includes(:activities, :nutritions, :scores, :school).all
    end

    @under8 = 0
    @pluls12 = 0
    @middle = 0
    @displaced = 0
    @disability = 0
    @drop = 0
    @graduated = 0
    @lost_year = 0
    @all = @students.count
    @hash_etnic = {}
    @overallscore = {}

    @results = {
        "Delgadez severa" => {data: 0, girls: 0, boys: 0, good: 0, bad: 0},
        "Delgadez" => {data: 0, girls: 0, boys: 0, good: 0, bad: 0},
        "Riesgo de delgadez" => {data: 0, girls: 0, boys: 0, good: 0, bad: 0},
        "Adecuado para la edad" => {data: 0, girls: 0, boys: 0, good: 0, bad: 0},
        "Sobrepeso" => {data: 0, girls: 0, boys: 0, good: 0, bad: 0},
        "Obesidad" => {data: 0, girls: 0, boys: 0, good: 0, bad: 0}
    }

    if !@students.present?
      @students = Student.includes(:activities, :nutritions, :scores, :school).all
    end

    @actividad = {}
    @students.each do |student|

      #programs activities
      if student.activities.present?
        student.activities.each do |activity|
          if @actividad.key?(activity.name)
            @actividad[activity.name][:students]+=1
            student.assistances.where(activity_id: activity.id, assistance_mark: true).each do |assistance|
                @actividad[activity.name][:assistance]+=1
            end
          else
            @actividad[activity.name] = {students: 0, assistance: 0, program: activity.program.name}

          end
          #  activity.assistances.each do |assistance|
          # 	 assistance.student.try(:name)
          # 	 assistance.try(:assistance_mark)
          # end
        end
      end
      #/programs activities


      # gender
      if student.gender == "masculino"
        @boys += 1
      else
        student.gender == "femenino"
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

      if student.lost_year == true
        @lost_year += 1
      end

      #nutrition
      if student.nutritions.present?
        #@cuantos = student.nutritions.count - 1

        if params[:year].present? && params[:year][:year_number].present?
          @year = params[:year][:year_number]
          @much = 0
          @all_nutritions = 0
          student.nutritions.each do |nutrition|
            if params[:period].present? && params[:period][:period_number].present?
              if @year.to_s == nutrition.year.to_s && params[:period][:period_number].to_s == nutrition.period.to_s
                @much += 1
                @all_nutritions += nutrition.imc
              end
            else
              if @year.to_s == nutrition.year.to_s
                @much += 1
                @all_nutritions += nutrition.imc
              end
            end
          end
          @imc = @all_nutritions/(@much > 0 ? @much : 1)
        else
          @much = 0
          @all_nutritions = 0
          student.nutritions.each do |nutrition|
            @much += 1
            @all_nutritions += nutrition.imc
          end
          @imc = @all_nutritions/(@much > 0 ? @much : 1)
        end

        if @imc <= GeneralInfo.nutrition_points[student.gender]["lower"]
          @results["Delgadez severa"][:data] += 1
          # gender
          if student.gender == "femenino"
            @results["Delgadez severa"][:girls] += 1
          else
            @results["Delgadez severa"][:boys] += 1
          end
          # /gender
          if student.touchdown
            @results["Delgadez severa"][:good] += 1
          else
            @results["Delgadez severa"][:bad] += 1
          end

        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["lower"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["minimum"]
          @results["Delgadez"][:data] += 1
          if student.gender == "femenino"
            @results["Delgadez"][:girls] += 1
          else
            @results["Delgadez"][:boys] += 1
          end
          if student.touchdown
            @results["Delgadez"][:good] += 1
          else
            @results["Delgadez"][:bad] += 1
          end
        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["minimum"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_min"]
          @results["Riesgo de delgadez"][:data] += 1
          if student.gender == "femenino"
            @results["Riesgo de delgadez"][:girls] += 1
          else
            @results["Riesgo de delgadez"][:boys] += 1
          end
          if student.touchdown
            @results["Riesgo de delgadez"][:good] += 1
          else
            @results["Riesgo de delgadez"][:bad] += 1
          end
        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_min"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_max"]
          @results["Adecuado para la edad"][:data] += 1
          if student.gender == "femenino"
            @results["Adecuado para la edad"][:girls] += 1
          else
            @results["Adecuado para la edad"][:boys] += 1
          end
          if student.touchdown
            @results["Adecuado para la edad"][:good] += 1
          else
            @results["Adecuado para la edad"][:bad] += 1
          end
        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_max"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["maximum"]
          @results["Sobrepeso"][:data] += 1
          if student.gender == "femenino"
            @results["Sobrepeso"][:girls] += 1
          else
            @results["Sobrepeso"][:boys] += 1
          end
          if student.touchdown
            @results["Sobrepeso"][:good] += 1
          else
            @results["Sobrepeso"][:bad] += 1
          end
        elsif @imc >= GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["maximum"]
          @results["Obesidad"][:data] += 1
          if student.gender == "femenino"
            @results["Obesidad"][:girls] += 1
          else
            @results["Obesidad"][:boys] += 1
          end
          if student.touchdown
            @results["Obesidad"][:good] += 1
          else
            @results["Obesidad"][:bad] += 1
          end
        end
      end

      #/ Nutrition

      # Etnias
      if @hash_etnic.key?(student.etnic)
        @hash_etnic[student.etnic][:number]+= 1
        # nutrition
        #@cuantos = student.nutritions.count - 1
        if params[:year].present? && params[:year][:year_number].present?
          @year = params[:year][:year_number]
          @much = 0
          @all_nutritions = 0
          student.nutritions.each do |nutrition|
            if params[:period].present? && params[:period][:period_number].present?
              if @year.to_s == nutrition.year.to_s && params[:period][:period_number].to_s == nutrition.period.to_s
                @much += 1
                @all_nutritions += nutrition.imc
              end
            else
              if @year.to_s == nutrition.year.to_s
                @much += 1
                @all_nutritions += nutrition.imc
              end
            end
          end
          @imc = @all_nutritions/(@much > 0 ? @much : 1)
        else
          @much = 0
          @all_nutritions = 0
          student.nutritions.each do |nutrition|
            @much += 1
            @all_nutritions += nutrition.imc
          end
          @imc = @all_nutritions/(@much > 0 ? @much : 1)
        end

        if @imc <= GeneralInfo.nutrition_points[student.gender]["lower"]
          @hash_etnic[student.etnic]["Delgadez severa"]+= 1
        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["lower"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["minimum"]
          @hash_etnic[student.etnic]["Delgadez"]+= 1
        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["minimum"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_min"]
          @hash_etnic[student.etnic]["Riesgo de delgadez"]+= 1
        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_min"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_max"]
          @hash_etnic[student.etnic]["Adecuado para la edad"]+= 1
        elsif @imc > GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["medium_max"] && @imc < GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["maximum"]
          @hash_etnic[student.etnic]["Sobrepeso"]+= 1
        elsif @imc >= GeneralInfo.nutrition_points_five[student.age_medium][student.gender]["maximum"]
          @hash_etnic[student.etnic]["Obesidad"]+= 1
        end
        # /nutrition
      else
        @hash_etnic[student.etnic] = {
            number: 0,
            "Delgadez severa" => 0,
            "Delgadez" => 0,
            "Riesgo de delgadez" => 0,
            "Adecuado para la edad" => 0,
            "Sobrepeso" => 0,
            "Obesidad" => 0
        }
      end
      # /Etnias

      # Grades
      if student.scores.present?
        @many = 0
        @all_scores = 0
        student.scores.each do |score|
          if params[:year].present? && params[:year][:year_number].present? && !params[:period][:period_number].present? # if year
            if params[:year][:year_number].to_s == score.year.to_s
              if @overallscore.key?(score.area)
                @overallscore[score.area][:many] += 1
                @overallscore[score.area][:all] += score.score.to_f
              else
                @overallscore[score.area] = {many: 0, all: 0.to_f, name: score.area}
              end
            end
          elsif params[:year].present? && params[:year][:year_number].present? && params[:period].present? && params[:period][:period_number].present?
            if params[:period][:period_number].to_s == score.period.to_s && params[:year][:year_number].to_s == score.year.to_s
              if @overallscore.key?(score.area)
                @overallscore[score.area][:many] += 1
                @overallscore[score.area][:all] += score.score.to_f
              else
                @overallscore[score.area] = {many: 0, all: 0.to_f, name: score.area}
              end
            end
          else # else if not year
            if @overallscore.key?(score.area)
              @overallscore[score.area][:many] += 1
              @overallscore[score.area][:all] += score.score.to_f
            else
              @overallscore[score.area] = {many: 0, all: 0.to_f, name: score.area}
            end
          end # /else if not year
        end
      end
      # /grades
    end

    # grades
    @finish_grades = {
        name: 'Calificaciones academicas',
        colorByPoint: true,
        data: []
    }

    @overallscore.each do |key, score|
      @finish_grades[:data].push({name: key, y: (score[:all]/(score[:many] > 0 ? score[:many] : 1)).round(1)})
    end
    # /grades

    # Etnias

    @finish_etnias = {
        name: 'Etnias',
        colorByPoint: true,
        data: []
    }
    @drilldown = {
        series: []
    }

    @hash_etnic.each do |key, etnics|
      @finish_etnias[:data].push({name: key, y: etnics[:number], drilldown: key});
      @drilldown[:series].push({name: key, id: key, data: [["Delgadez severa", etnics["Delgadez severa"]], ["Delgadez", etnics["Delgadez"]], ["Riesgo de delgadez", etnics["Riesgo de delgadez"]], ["Adecuado para la edad", etnics["Adecuado para la edad"]], ["Sobrepeso", etnics["Sobrepeso"]], ["Obesidad", etnics["Obesidad"]]]})
    end
    # / Etnias
    @cuales_actividades = []
    @asistio = []
    @noasistio = []

    @actividad.each do |key, actividad|
      @cuales_actividades.push(key)
      @asistio.push(actividad[:students]-actividad[:assistance])
      @noasistio.push(actividad[:assistance])
    end

    p "@actividad"
    p @actividad

  end

end