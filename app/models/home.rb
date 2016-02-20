class Home < ActiveRecord::Base
  mount_uploader :pic, PictuareUploader
end
