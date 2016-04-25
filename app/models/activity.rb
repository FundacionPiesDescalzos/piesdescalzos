class Activity < ActiveRecord::Base
  belongs_to :program
	has_many :assistances
	has_many :students, through: :assistances
	accepts_nested_attributes_for :assistances
end
