class UserstarsController < ApplicationController
  require 'will_paginate/array'
  def index
    if current_user 
      @scroll = params[:scroll]
      @title = "Stars"
      @user = current_user
      @entries = current_user.stars.paginate(page: params[:page], per_page: 15)
      if ((Time.now - @user.weather.updated_at)/60 > 60)
        @user.weather.update_attributes(Apis::Weather.getWeather)
        @user.save
      end
      @geo = Geocoder::search(@user.location)[0]
      @tStatus = User.getTrains(@user)
      if @scroll == true
        respond_to do |format|
          format.html
          format.js
        end
      end
    else
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end

end