class AddOptionsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :disability, :boolean, :default => false
    add_column :students, :drop, :boolean, :default => false
    add_column :students, :pic, :string
  end
end
