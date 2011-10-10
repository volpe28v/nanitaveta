class PhotosController < ApplicationController
  def index
    @user = User.find(params[:user_id])
  end

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def destroy
    @photo = Photo.find(params[:id])
    @user = User.find(params[:user_id])

    @photo.destroy
    File.delete(Rails.root + "public/photos/" + @photo.path)

    redirect_to @user
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

end
