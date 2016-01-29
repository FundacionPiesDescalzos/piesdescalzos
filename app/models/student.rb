class Student < ActiveRecord::Base
  belongs_to :guardian
  belongs_to :school
  
  def the_school
    self.school.present? ? self.school.name : "Sin escuela"
  end
end
