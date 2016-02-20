class AddPicToHomes < ActiveRecord::Migration
  def change
    add_column :homes, :pic, :string
  end
end
