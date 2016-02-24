class SessionsController < ApplicationController

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      @user.location = request.remote_ip
      if @user.save
        if ((Time.now - @user.weather.updated_at)/60 > 60)
          @user.weather.update_attributes(Apis::Weather.getWeather)
        end
        session[:user_id] = @user.id 
        flash[:notice]="signed in"
        redirect_to current_user
      else
        flash[:notice]="sign in failed"
        redirect_to :back
      end
    else
      redirect_to :back
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
