class AddPicToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :pic, :string
  end
end
