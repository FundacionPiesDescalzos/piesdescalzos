class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :identification
      t.string :period
      t.string :area
      t.string :score
      t.belongs_to :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
