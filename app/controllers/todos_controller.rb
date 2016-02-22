class TodosController < ApplicationController
  def index
    @user = current_user
    respond_to do |format|
      format.html
      format.json { render :json => {response: @user.todos} }
    end
  end

  def new
    @todo = Todo.new
    respond_to do |format|
      format.html
      format.json { render :json => {response: @todo} }
    end
  end

  def create
    @todo = Todo.new(todo_params)
  end

  def show
    @todo = Todo.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => {response: @todo} }
    end
  end

  def edit
    @todo = Todo.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => {response: @todo} }
    end
  end

  def update
    @todo = Todo.find(params[:id])
    if @todo.update_attributes(todo_params)
      flash[:notice]='Updated'
      redirect_to @todo 
    else
      flash[:notice]='failed'
      redirect_to :back
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    if @todo.destroy
      flash[:notice]="Destroyed"
      redirect_to @current_user
    else
      flash[:notice]="failed"
      redirect_to :back
    end
  end

  private
  def todo_params
    params.require(:todo).permit(:date,:description).merge(user_id: current_user)
  end
end
