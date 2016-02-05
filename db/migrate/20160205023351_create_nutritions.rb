class CreateNutritions < ActiveRecord::Migration
  def change
    create_table :nutritions do |t|
      t.float :weight
      t.float :height
			t.string :period
			t.string :year 
      t.integer :identification, :limit => 8
      t.belongs_to :student, index: true, foreign_key: true
			t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
