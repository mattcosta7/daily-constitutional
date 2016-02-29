class TodosController < ApplicationController
  before_filter :validate

  def index
    @title = "Feed"
    @user = current_user
    if ((Time.now - @user.weather.updated_at)/60 > 60)
      @user.weather.update_attributes(Apis::Weather.getWeather)
      @user.save
    end
    @geo = Geocoder::search(@user.location)[0]
    @tStatus = User.getTrains(@user)
    @todos = @user.todos.where("duedate >= ?", Time.now-24.hours).order(:duedate).reverse 
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      redirect_to root_path
    else
      redirect_to :back
    end
  end

  def update
    @todo = Todo.find(params[:id])
    if @todo.update_attributes(todo_params)
      flash[:notice]='Updated'
      redirect_to root_path 
    else
      flash[:notice]='failed'
      redirect_to :back
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    if @todo.destroy
      flash[:notice]="Destroyed"
      redirect_to :back
    else
      flash[:notice]="failed"
      redirect_to :back
    end
  end

  def complete!
    @todo = Todo.find(params[:id])
    if @todo.user == current_user
      if @todo.update_attributes(is_completed: true)
        redirect_to :back
      else
        flash[:notice]="error"
        redirect_to :back
      end
    else
      flash[:notice]='wrong user'
      redirect_to :back
    end
  end

  def uncomplete!
    @todo = Todo.find(params[:id])
    if @todo.user == current_user
      if @todo.update_attributes(is_completed: false)
        redirect_to :back
      else
        flash[:notice]="error"
        redirect_to :back
      end
    else
      flash[:notice]='wrong user'
      redirect_to :back
    end
  end


  private
  def todo_params
    params.require(:todo).permit(:duedate,:description).merge(user_id: current_user.id)
  end

  def validate
    if !current_user
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end
end
