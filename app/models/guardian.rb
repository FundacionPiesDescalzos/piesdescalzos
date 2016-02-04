class Guardian < ActiveRecord::Base
  belongs_to :students
	validates :name, :identification, :id_type, :student_id,  presence: true
end
