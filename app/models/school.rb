class School < ActiveRecord::Base
  belongs_to :establishment
  has_many :students
	
	mount_uploader :pic, PicUploader
end
