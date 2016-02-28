class HomeController < ApplicationController
  def index
    if current_user
      @title = "Feed"
      @user = current_user
      if ((Time.now - @user.weather.updated_at)/60 > 60)
        @user.weather.update_attributes(Apis::Weather.getWeather)
        @user.save
      end
      @geo = Geocoder::search(@user.location)[0]
      @tStatus = User.getTrains(@user)
      @entries = @user.entries.order(:published).reverse.first(30)
    else
      @title = "Sign In"
    end
  end

  #if current user, redirect
end
