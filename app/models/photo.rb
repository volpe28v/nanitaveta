# coding : UTF-8

class Photo < ActiveRecord::Base
  belongs_to(:user)
  validates_presence_of :user_id

  OPEN_PROFILE_IMAGE_PATH = Rails.root + "public/photos/"

  def self.save_image(email)
    user = ""
    return false if (user = User.find_by_email(email.from[0])) == nil

    if email.has_attachments?
      self.create_image_original(email.attachments[0],self.create_photo_name(user,email))
      self.create_photo_table(email,user,self.create_photo_name(user,email))
    else
      return false
    end
    true
  end

  def self.create_photo_name(user,email)
    photo_name = "#{user.id}_#{email.date.strftime("%Y%m%d%H%M%S")}.jpg"
  end

  def self.create_photo_table(email,user,photo_name)
    photo = Photo.new
    photo.user_id  = user.id
    photo.path = photo_name
    photo.date = self.get_image_date(photo_name)
    photo.message = email.body.split("\r\n")[0..-2].join("\n").toutf8
    photo.save
  end

  def self.create_image_original(file,photo_name)
    File.open("#{OPEN_PROFILE_IMAGE_PATH}#{photo_name}", "w+b"){ |f| f.write(file.read) }
  end

  def self.get_image_date(photo_name)
    img = EXIFR::JPEG.new("#{OPEN_PROFILE_IMAGE_PATH}#{photo_name}")
    p img.date_time
    return img.date_time
  end


  def price
    /(\d+)円/ =~ self.message
    $1 ? $1.to_i : 0
  end
end
