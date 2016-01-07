class VisitorsController < ApplicationController
  def index
    if params[:search]
      s = "%#{params[:search]}%"
      if params[:search].to_i.is_a?(Integer)  && params[:search].to_i > 0
        @students = Student.where(identification: params[:search].to_i).limit(100)
      else
        @students = Student.where("lower(name) LIKE :search", search: s.downcase).limit(100)
      end
    else
      @students = Student.all.order(:name).limit(200)
    end
  end
end
