class UserstarsController < ApplicationController
  def index
    if current_user 
      @title = "Stars"
      @user = current_user
      @entries = current_user.stars
      if ((Time.now - @user.weather.updated_at)/60 > 60)
        @user.weather.update_attributes(Apis::Weather.getWeather)
        @user.save
      end
      @geo = Geocoder::search(@user.location)[0]
      @tStatus = User.getTrains(@user)
    else
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end

end