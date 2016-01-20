class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :name
      t.text :paragraph
      t.string :email
      t.json :pictures
      t.text :texto

      t.timestamps null: false
    end
  end
end
