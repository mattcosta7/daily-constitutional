class TodosController < ApplicationController
  def index
    if current_user
      @user = current_user
      respond_to do |format|
        format.html
        format.json { render :json => {response: @user.todos} }
      end
    else
      redirect_to root_path
    end
  end

  def new
    if current_user
      @todo = Todo.new
      respond_to do |format|
        format.html
        format.json { render :json => {response: @todo} }
      end
    else
      redirect_to root_path
    end
  end

  def create
    if current_user
      @todo = Todo.new(todo_params)
      if @todo.save
        redirect_to current_user
      else
        redirect_to :back
      end
    else
       redirect_to root_path
    end 
  end

  def show
    if current_user
      @todo = Todo.find(params[:id])
      respond_to do |format|
        format.html
        format.json { render :json => {response: @todo} }
      end
    else
      redirect_to root_path
    end
  end

  def edit
    if current_user
      @todo = Todo.find(params[:id])
      respond_to do |format|
        format.html
        format.json { render :json => {response: @todo} }
      end
    else
      redirect_to root_path
    end
  end

  def update
    if current_user
      @todo = Todo.find(params[:id])
      if @todo.update_attributes(todo_params)
        flash[:notice]='Updated'
        redirect_to @todo 
      else
        flash[:notice]='failed'
        redirect_to :back
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    if current_user
      @todo = Todo.find(params[:id])
      if @todo.destroy
        flash[:notice]="Destroyed"
        redirect_to @current_user
      else
        flash[:notice]="failed"
        redirect_to :back
      end
    else
      redirect_to root_path
    end
  end

  private
  def todo_params
    params.require(:todo).permit(:duedate,:description).merge(user_id: current_user.id)
  end
end
