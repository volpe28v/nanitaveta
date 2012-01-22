class PhotosController < ApplicationController
  before_filter :authenticate_user! 

  def index
    @user = User.find(params[:user_id])

    @photos_hash = {}
    @price_hash = {}
    @user.photos.order("date ASC").each do |p|
      current_date = p.date.strftime("%Y/%m/%d")
      @photos_hash[current_date] ||= []
      @photos_hash[current_date] << p

      current_month = p.date.strftime("%Y/%m")
      @price_hash[current_month] ||= 0
      @price_hash[current_month] += p.price
    end
  end

  def dinner
    @user = User.find(params[:user_id])

    @photos_hash = new_base_photos_hash
    @user.photos.week.order("date ASC").each do |p|
      if p.is_dinner?
        current_date = p.date.strftime("%Y/%m/%d")
        @photos_hash[current_date] ||= []
        @photos_hash[current_date] << p
      end
    end
  end

  def breakfast
    @user = User.find(params[:user_id])

    @photos_hash = new_base_photos_hash
    @user.photos.week.order("date ASC").each do |p|
      if p.is_breakfast?
        current_date = p.date.strftime("%Y/%m/%d")
        @photos_hash[current_date] ||= []
        @photos_hash[current_date] << p
      end
    end
  end

  def new_base_photos_hash
    photos_hash = {}
    today = Date.today
    index_date = today - 6
    while index_date <= today
      current_date = index_date.strftime("%Y/%m/%d")
      photos_hash[current_date] ||= []
      index_date += 1
    end

    photos_hash
  end

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(params[:user_id])

    photos = @user.photos.order("date ASC")
    found_i = 0
    photos.each_with_index do |p,i|
      if p == @photo
        found_i = i
        break
      end
    end
    pre_photo  = photos[found_i - 1]
    next_photo = photos[found_i] == photos.last ? photos.first : photos[found_i + 1]

    current_date = @photo.date.strftime("%Y/%m/%d")
    pre_date     = pre_photo.date.strftime("%Y/%m/%d")
    next_date    = next_photo.date.strftime("%Y/%m/%d")

    @pre_next = []
    @pre_next << {:photo => pre_photo, :date => current_date == pre_date ? "" : pre_date }
    @pre_next << {:photo => next_photo, :date => current_date == next_date ? "" : next_date }
  end

  def destroy
    @photo = Photo.find(params[:id])
    @user = User.find(params[:user_id])

    @photo.destroy
    File.delete(Rails.root + "public/photos/" + @photo.path)

    redirect_to user_photos_path
  end

  def edit
    @photo = Photo.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def update
    photo = Photo.find(params[:id])
    user = User.find(params[:user_id])

    photo.update_attributes(params[:photo])

    redirect_to user_photo_path(user,photo)
  end

  def calendar
  end

  def gallery
    @user = User.find(params[:user_id])
    @photos = @user.photos.order("date DESC")

  end
end
