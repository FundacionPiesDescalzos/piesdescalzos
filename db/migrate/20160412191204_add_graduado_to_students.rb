class AddGraduadoToStudents < ActiveRecord::Migration
  def change
    add_column :students, :why, :text
    add_column :students, :graduated, :boolean, :default => false
  end
end
