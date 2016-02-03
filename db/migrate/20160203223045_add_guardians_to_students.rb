class AddGuardiansToStudents < ActiveRecord::Migration
  def change
    add_reference :guardians, :student, index: true, foreign_key: true
  end
end
