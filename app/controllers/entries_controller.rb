class EntriesController < ApplicationController

  def index
    if current_user
      @entries = current_user.blogs.entries.all.order(published: :desc)
    else
      redirect_to root_path
    end
  end

  def show
    if current_user
      @entry = Entry.find(params[:id])
    else
      redirect_to root_path
    end
  end

  def destroy
    if current_user
      @entry = Entry.find(params[:id])
      @entry.destroy
      redirect_to current_user
    else
      redirect_to root_path
    end
  end
end