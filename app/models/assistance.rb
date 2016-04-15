class Assistance < ActiveRecord::Base
  belongs_to :activity
  belongs_to :student
end