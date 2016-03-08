class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
    respond_to do |format|
        format.html
        format.csv { send_data @students.to_csv }
      end
  end

  # GET /students/1
  # GET /students/1.json
  def show
		@guardian = @student.guardian || Guardian.new
		@health_care = @student.health_care || HealthCare.new
    @schools = School.all
		@activities = Activity.joins(:students).where(students: {id: @student.id})
		@programs_edu =	Program.where(line: "epc").joins(:activities).where(activities: {id: @activities})
		@programs_m =	Program.where(line: "n").joins(:activities).where(activities: {id: @activities})
		@programs_h =	Program.where(line: "h").joins(:activities).where(activities: {id: @activities})
  end

  # GET /students/new
  def new
    @student = Student.new
	  @student.build_guardian
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'El estudiante fue actualizado.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to visitors_url, notice: 'El estudiante fue borrado.' }
      format.json { head :no_content }
    end
  end
	
  def import
    @importar = Student.import(params[:file],params[:school_id])
		if @importar.status == :done
	    redirect_to school_url(params[:school_id]), notice: @importar.message
		else
			redirect_to school_url(params[:school_id]), alert: @importar.message
		end
  end
	

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :id_type, :gender, :address, :last_course, :outschool_years, :identification, :born, :etnic, :villa, :born_state, :displaced, :residency_state, :zone, :guardian_id, :school_id, :health_care_id, guardian_attributes: [:id_type, :identification, :name, :last_name, :second_name, :gender, :born, :address, :villa, :zone, :department, :municipality, :phone, :cel, :email, :relationship, :student_id])
    end
end
