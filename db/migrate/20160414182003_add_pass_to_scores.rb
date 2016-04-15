class AddPassToScores < ActiveRecord::Migration
  def change
    add_column :scores, :pass, :boolean, :default => false
  end
end
