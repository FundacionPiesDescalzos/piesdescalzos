class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.integer :code
      t.string :name
      t.string :address
      t.string :neighborhood
      t.string :zone
      t.string :contact_name
      t.string :contact_position
      t.string :phone
      t.string :email
      t.boolean :headquarter
      t.boolean :foundation_present
      t.belongs_to :establishment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
