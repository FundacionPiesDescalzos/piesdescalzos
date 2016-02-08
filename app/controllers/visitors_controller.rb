class VisitorsController < ApplicationController
	before_action :authenticate_user!
  def index
    @schools = School.all
    if params[:search]
      s = "%#{params[:search]}%"
      i = "#{params[:instituciones]}"
      if params[:search].to_i.is_a?(Integer)  && params[:search].to_i > 0 && !i.present?
        @students = Student.where(identification: params[:search].to_i)
      elsif params[:search].to_i.is_a?(Integer) && params[:search].to_i > 0 && i.present?
				p 2
        @students = Student.where(identification: params[:search].to_i)
				@students = @students.select { |h| h.school.id == i.to_i }
      else
				if i.present?
	        @students = Student.where("lower(name) LIKE :search", search: s.downcase)
					@students = @students.select { |h| h.school.id == i.to_i }
				else
					@students = Student.where("lower(name) LIKE :search", search: s.downcase)
				end
      end
    else
      @students = Student.all.order(:name).limit 50
    end
  end
end
