class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :identification
      t.string :period
      t.integer :went_days
      t.integer :skip_days
      t.text :reason
      t.belongs_to :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
