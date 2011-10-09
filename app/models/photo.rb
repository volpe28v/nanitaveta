class Photo < ActiveRecord::Base
  belongs_to(:user)
  validates_presence_of :user_id

  OPEN_PROFILE_IMAGE_PATH = Rails.root + "public/photos/"

  def self.save_image(email)
    user = nil
    if (user = User.find_by_email(email.from[0])) != nil
      self.create_photo_table(email,user,self.create_photo_name(user,email))

      if email.has_attachments?
        self.create_image_original(email.attachments[0],self.create_photo_name(user,email))
      end
    end
  end

  def self.create_photo_name(user,email)
    photo_name = "#{user.id}_#{email.date.strftime("%Y%m%d%H%M%S")}.jpg"
  end

  def self.create_photo_table(email,user,photo_name)
    photo = Photo.new
    photo.user_id  = user.id
    photo.path = photo_name
    photo.date = email.date
    photo.message = email.body.split("\r\n")[0].toutf8
    photo.save
  end

  def self.create_image_original(file,photo_name)
    File.open("#{OPEN_PROFILE_IMAGE_PATH}#{photo_name}", "w+b"){ |f| f.write(file.read) }
  end
end
