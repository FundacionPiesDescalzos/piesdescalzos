class Student < ActiveRecord::Base
  belongs_to :guardian
  belongs_to :school
end
