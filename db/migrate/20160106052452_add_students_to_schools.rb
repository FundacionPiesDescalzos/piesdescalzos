class AddStudentsToSchools < ActiveRecord::Migration
  def change
    add_reference :students, :school, index: true, foreign_key: true
    add_reference :health_cares, :student, index: true, foreign_key: true
  end
end
