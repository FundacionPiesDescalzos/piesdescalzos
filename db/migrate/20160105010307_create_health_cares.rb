class CreateHealthCares < ActiveRecord::Migration
  def change
    create_table :health_cares do |t|
      t.boolean :affiliate
      t.string :regime
      t.string :eps
      t.string :ips
      t.boolean :register
      t.string :card
      t.date :poll_date
      t.float :score
      t.boolean :inhabilites
      t.text :inh_description

      t.timestamps null: false
    end
  end
end
