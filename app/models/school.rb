class School < ActiveRecord::Base
  belongs_to :establishment
  has_many :students, dependent: :destroy
	
	mount_uploader :pic, PicUploader
end
