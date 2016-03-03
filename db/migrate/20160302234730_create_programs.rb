class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.string :line
      t.string :city
      t.text :description
      t.boolean :active

      t.timestamps null: false
    end
  end
end
