class AddYearToScores < ActiveRecord::Migration
  def change
    add_column :scores, :year, :string
		add_column :scores, :user_id, :integer
  end
end
