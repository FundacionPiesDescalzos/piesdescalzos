class AddSlideToHomes < ActiveRecord::Migration
  def change
    add_column :homes, :slide, :boolean
  end
end
