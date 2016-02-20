class ChangePictuaresTypeInHomes < ActiveRecord::Migration
  def up
	   change_column :homes, :pictures, :string
  end
  def down
	   change_column :homes, :pictures, :json
  end
end
