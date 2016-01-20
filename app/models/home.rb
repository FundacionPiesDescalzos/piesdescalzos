class Home < ActiveRecord::Base
  mount_uploader :pictuares, PictuareUploader
end
