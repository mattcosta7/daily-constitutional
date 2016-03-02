class UsersController < ApplicationController
  before_filter :validate!, except: [:new,:create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.location = request.remote_ip
    if @user.save
      @weather = Weather.new(Apis::Weather.getWeather)
      if @weather.save
        @weather.update_attribute(:user_id,@user.id)
        flash[:notice]='Sign Up Completed'
        session[:user_id]=@user.id
        redirect_to suggestions_path
      else
        flash[:notice]='fail'
        redirect_to :back
      end
    else
      redirect_to :back
    end
  end

  def show
    @scroll = params[:scroll]
    @title = "Feed"
    @user = current_user
    if ((Time.now - @user.weather.updated_at)/60 > 60)
     @user.weather.update_attributes(Apis::Weather.getWeather)
     @user.save
    end
    @geo = Geocoder.search(@user.location)[0]
    @tStatus = User.getTrains(@user)
    @entries = @user.entries.order(:published).reverse.paginate(page: params[:page], per_page: 24)
    if @scroll == true
     respond_to do |format|
       format.html
       format.js
     end
    end
    redirect_to root_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice]='Updated'
      redirect_to root_path 
    else
      flash[:notice]='failed'
      redirect_to :back
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.authenticate(params[:user][:password])
      if @user.destroy
        flash[:notice]="Destroyed User"
        session.clear
        redirect_to root_path
      else
        flash[:notice]="Failed"
        redirect_to :back
      end
    else
      flash[:notice]="Incorrect Password"
      redirect_to :back
    end
  end

  def removefeed
    @user = current_user
    @blog = Blog.find(params[:id])
    if @user.blogs.include?(@blog)
      if @user.reader_blogs.find_by_blog_id(params[:id]).destroy
        flash[:notice]="demolished that suckka"
        redirect_to :back
      else
        flash[:notice]="couldn't get it done"
        redirect_to :back
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,:latitude, :longitude)
  end

  def validate!
    if !current_user
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end

end
