class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.integer :code
      t.string :name
      t.string :department
      t.string :state
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
  end
end
