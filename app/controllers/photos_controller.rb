class PhotosController < ApplicationController
  def index
    @user = User.find(params[:user_id])

    @photos_hash = {}
    @user.photos.order("date ASC").each do |p|
      current_date = p.date.strftime("%Y/%m/%d")
      @photos_hash[current_date] ||= []
      @photos_hash[current_date] << p
    end

  end

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(params[:user_id])

    photos = @user.photos.order("date DESC")
    found_i = 0
    photos.each_with_index do |p,i|
      if p == @photo
        found_i = i
        break
      end
    end
    @pre  = photos[found_i - 1]
    @next = photos[found_i] == photos.last ? photos.first : photos[found_i + 1]
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

end
