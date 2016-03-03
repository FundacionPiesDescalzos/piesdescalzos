class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.date :the_date
      t.string :boss
      t.boolean :active
			t.text :description
      t.belongs_to :program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
