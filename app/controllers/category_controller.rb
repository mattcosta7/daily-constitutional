class CategoryController < ApplicationController
  require 'will_paginate/array'
  before_filter :validate!
  


  def show
    @scroll = params[:scroll]
    @user = current_user
    @category = Category.find(params[:id])
    @entries = []
    @category.blogs.each do |blog|
      if current_user.blogs.include?(blog)
        blog.entries.each do |entry|
          @entries << entry
        end
      end
    end
    if @entries.length > 0
      @title = @category.title
      if ((Time.now - @user.weather.updated_at)/60 > 60)
        @user.weather.update_attributes(Apis::Weather.getWeather)
        @user.save
      end
      @geo = Geocoder::search(@user.location)[0]
      @tStatus = User.getTrains(@user) 
      @entries = @entries.reverse.paginate(page: params[:page], per_page: 15)   
      if @scroll == true
        respond_to do |format|
          format.html
          format.js
        end
      end
    else
      flash[:notice] = "You Don't Have Feeds Of That Type"
      redirect_to root_path
    end
  end

  private

  def validate!
    if !current_user
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end

end