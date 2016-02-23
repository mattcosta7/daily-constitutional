class UserstarsController < ApplicationController
  def index
    if current_user 
      @user = current_user
      @entries = current_user.stars
    else
      redirect_to root_path
    end
  end

end