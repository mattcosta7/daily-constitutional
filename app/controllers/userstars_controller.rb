class UserstarsController < ApplicationController
  def index
    @user = current_user
    @entries = current_user.stars
  end

end