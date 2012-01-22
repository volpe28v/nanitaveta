# coding : UTF-8

class Photo < ActiveRecord::Base
  belongs_to(:user)
  validates_presence_of :user_id

  OPEN_PROFILE_IMAGE_PATH = Rails.root + "public/photos/"

  def self.save_image(email)
    user = ""
    return false if (user = User.find_by_email(email.from[0])) == nil

    if email.has_attachments?
      email.attachments.each_with_index {|attach, i|
        photo_name = self.create_photo_name(user,email,i)
        self.create_image_original(attach,photo_name)
        self.create_photo_table(email,user,photo_name)
      }
    else
      return false
    end
    true
  end

  def self.create_photo_name(user,email,index)
    photo_name = "#{user.id}_#{email.date.strftime("%Y%m%d%H%M%S_#{index}")}.jpg"
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

  def is_eating_out?
    self.price > 0 ? true : false
  end

  def is_dinner?
    self.date > Time.local(self.date.year, self.date.month, self.date.day, 18, 00)
  end

  def is_breakfast?
    if self.date >= Time.local(self.date.year, self.date.month, self.date.day, 6, 00) and self.date < Time.local(self.date.year, self.date.month, self.date.day, 11, 00)
      true
    else
      false
    end
  end

  scope :week, where('date > ?', Date.today - 6)
end
