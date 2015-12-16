class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :id_type
      t.string :gender
      t.string :address
      t.string :last_course
      t.integer :outschool_years
      t.integer :identification
      t.date :born
      t.string :etnic
      t.string :villa
      t.string :born_state
      t.string :displaced
      t.string :residency_state
      t.string :zone
      t.belongs_to :guardian, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
