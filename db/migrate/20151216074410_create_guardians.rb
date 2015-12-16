class CreateGuardians < ActiveRecord::Migration
  def change
    create_table :guardians do |t|
      t.string :id_type
      t.integer :identification
      t.string :name
      t.string :last_name
      t.string :second_name
      t.string :gender
      t.date :born
      t.string :address
      t.string :villa
      t.string :zone
      t.string :department
      t.string :municipality
      t.string :phone
      t.string :cel
      t.string :email
      t.string :relationship

      t.timestamps null: false
    end
  end
end
