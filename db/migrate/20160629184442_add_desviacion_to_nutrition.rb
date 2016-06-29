class AddDesviacionToNutrition < ActiveRecord::Migration
  def change
    add_column :nutritions, :desviacion, :integer
  end
end
