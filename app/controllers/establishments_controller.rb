class EstablishmentsController < ApplicationController
  before_action :set_establishment, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

  # GET /establishments
  # GET /establishments.json
  def index
    @establishment = Establishment.new
    @establishments = Establishment.search(params[:search])
		@school = School.new
    respond_to do |format|
        format.html
        format.csv { send_data @establishments.to_csv }
      end
  end

  # GET /establishments/1
  # GET /establishments/1.json
  def show
  end

  # GET /establishments/new
  def new
    @establishment = Establishment.new
  end

  # GET /establishments/1/edit
  def edit
  end

  # POST /establishments
  # POST /establishments.json
  def create
    @establishment = Establishment.new(establishment_params)

    respond_to do |format|
      if @establishment.save
        format.html { redirect_to establishments_url, notice: 'La institución ha sido creada exitosamente.' }
        format.json { render :show, status: :created, location: @establishment }
      else
        format.html { render :new }
        format.json { render json: @establishment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /establishments/1
  # PATCH/PUT /establishments/1.json
  def update
    respond_to do |format|
      if @establishment.update(establishment_params)
        format.html { redirect_to establishments_url, notice: 'La institución ha sido actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @establishment }
      else
        format.html { render :edit }
        format.json { render json: @establishment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /establishments/1
  # DELETE /establishments/1.json
  def destroy
    @establishment.destroy
    respond_to do |format|
      format.html { redirect_to establishments_url, notice: 'Establishment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def import
    Establishment.import(params[:file])
    redirect_to establishments_url, notice: "Establecimientos importados."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_establishment
      @establishment = Establishment.find(params[:id])
    end
 
     # Never trust parameters from the scary internet, only allow the white list through.
    def establishment_params
      params.require(:establishment).permit(:code, :name, :department, :state, :phone, :email)
    end
end
