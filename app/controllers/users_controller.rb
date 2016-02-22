class UsersController < ApplicationController
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render :json => {response: @users} }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.json { render :json => {response: @user} }
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @weather = Weather.new(Apis::Weather.getWeather)
      if @weather.save
        @weather.update_attribute(:user_id,@user.id)
        flash[:notice]='works'
        session[:user_id]=@user.id
        redirect_to @user
      else
        flash[:notice]='fail'
        redirect_to :back
      end
    end
  end

  def show
    @user = User.find(params[:id])
    if ((Time.now - @user.weather.updated_at)/60 > 60)
      @user.weather.update_attributes(Apis::Weather.getWeather)
    end
    if @user.distance_from("New York City") <= 50
      @tStatus = Apis::Mta.get
    end
    respond_to do |format|
      format.html
      format.json { render :json => {user: @user, delays: @tStatus, weather: @weather} } 
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => {response: @user} }
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice]='Updated'
      redirect_to @user 
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

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,:latitude, :longitude).merge(location: request.remote_ip)
  end
end
