class UsersController < ApplicationController
  def index
    if current_user
      redirect_to user_photos_path(current_user)
    elsif
      redirect_to new_user_session_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def sync_now
    if MailAttachedHandler.download_imap
      render :text => "OK"
    else
      render :text => "NONE"
    end
  end
end
