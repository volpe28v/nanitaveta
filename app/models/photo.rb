class Photo < ActiveRecord::Base
  belongs_to(:user)
  validates_presence_of :user_id

  OPEN_PROFILE_IMAGE_PATH = Rails.root + "/public/photos/"

  def self.regist_profile_photo_open(email)
    if User.entried_address?(email.from[0])
      user = User.find_by_mailaddress(email.from[0])
      unless Photo.find_by_user_id(user.id)
        self.create_photo_table(email,user,self.create_photo_name(user))
      end
      if email.has_attachments?
        self.create_image_original(email.attachments[0],self.create_photo_name(user))
      end
    end
  end

  def self.create_photo_name(user)
    photo_name = {}
    original_name = "#{user.id}_original.jpg"
    photo_name["original"] = original_name 
    photo_name
  end
def self.create_photo_table(email,user,photo_name)
    photo = Photo.new
    photo.user_id  = user.id
    photo.path = photo_name["original"]
    photo.save
  end

  def self.create_image_original(file,photo_name)
    File.open("#{OPEN_PROFILE_IMAGE_PATH}#{photo_name['original']}", "w+b"){ |f| f.write(file.read) }
  end
end
