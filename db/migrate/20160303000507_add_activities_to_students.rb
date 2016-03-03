class AddActivitiesToStudents < ActiveRecord::Migration
  def change
	  create_table 'activities_students', :id => false do |t|
	     t.column :activity_id, :integer, index: true
	     t.column :student_id, :integer, index: true
	  end
  end
end
