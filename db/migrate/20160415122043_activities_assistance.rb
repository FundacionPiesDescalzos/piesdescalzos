class ActivitiesAssistance < ActiveRecord::Migration
  def change
	  create_table :assistances do |t|
       t.belongs_to :activity, index: true
       t.belongs_to :student, index: true
       t.boolean :assistance_mark
       t.timestamps null: false
     end
  end
end
