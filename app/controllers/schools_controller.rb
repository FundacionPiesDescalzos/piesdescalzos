class SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /schools
  # GET /schools.json
  def index
    @schools = School.all
  end

  # GET /schools/1
  # GET /schools/1.json
  def show
		@students = Student.where(school_id: @school.id)
		@group = {"1"=>[],"2"=>[],"3"=>[],"4"=>[],"5"=>[],"6"=>[],"7"=>[],"8"=>[],"9"=>[],"10"=>[],"11"=>[],"12"=>[]}
		@st = []
		@students.each do |student|
			@group[student.last_course].push(student.average)
			p student.average	
		end
		@group.reject!{ |k,v| !v.any? }
		@courses = [];
		@grades = [];
		@group.each do |k,v|
			@group[k] = added(v);
			@courses.push(k);
			@grades.push(v[0].round(2));
		end
		@title = "Informe del " + (Time.now.year-1).to_s + " al " + (Time.now.year).to_s
  end
	
	def added(arr)
		arr.inject(0){|sum,x| sum + x }.to_f / arr.size
	end

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools
  # POST /schools.json
  def create
    @school = School.new(school_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: 'La sede ha sido creada exitosamente.' }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1
  # PATCH/PUT /schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to @school, notice: 'La sede ha sido actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    @school.destroy
    respond_to do |format|
      format.html { redirect_to schools_url, notice: 'School was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
     
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_params
      params.require(:school).permit(:code, :name, :address, :neighborhood, :zone, :contact_name, :contact_position, :phone, :email, :headquarter, :foundation_present, :establishment_id)
    end
end
