class HomeController < ApplicationController
  require 'will_paginate/array'
  def index
    if current_user
      @scroll = params[:scroll]
      @title = "Feed"
      @user = current_user
      if ((Time.now - @user.weather.updated_at)/60 > 60)
        @user.weather.update_attributes(Apis::Weather.getWeather)
        @user.save
      end
      @geo = Geocoder.search(@user.location)[0]
      @tStatus = User.getTrains(@user)
      @entries = @user.entries.order(:published).reverse.paginate(page: params[:page], per_page: 15)
      if @scroll == true
        respond_to do |format|
          format.html
          format.js
        end
      end
    else
      @title = "Sign In"
    end
  end

  #if current user, redirect
end
