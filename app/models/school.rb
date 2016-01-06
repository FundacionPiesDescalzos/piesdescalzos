class School < ActiveRecord::Base
  belongs_to :establishment
  has_many :students
end
