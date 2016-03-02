class SessionsController < ApplicationController

#creates a session, checks to see if the weather has been updated recently for that user,
#only after authenticating
  def create
    if !current_user
      @user = User.find_by_email(params[:session][:email])
      if @user && @user.authenticate(params[:session][:password])
        @user.location = request.remote_ip
        if @user.save
          if ((Time.now - @user.weather.updated_at)/60 > 60)
            @user.weather.update_attributes(Apis::Weather.getWeather)
          end
          session[:user_id] = @user.id 
          flash[:notice]="Welcome Back!"
          redirect_to root_path
        else
          flash[:notice]="Something Went Horribly Wrong There"
          redirect_to :back
        end
      else
        flash[:notice]="Something Went Horribly Wrong There"
        redirect_to :back
      end
    else
      redirect_to root_path
    end
  end

#destroys a session, and clears cookies
  def destroy
    if current_user
      session.clear
      flash[:notice]="COME BACK!!!"
      redirect_to root_path
    else 
      redirect_to root_path
    end
  end

end
