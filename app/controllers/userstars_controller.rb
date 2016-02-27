class UserstarsController < ApplicationController
  def index
    if current_user 
      @title = "Stars"
      @user = current_user
      @entries = current_user.stars
    else
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end

end