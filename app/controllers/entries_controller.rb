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


  def star
    if current_user
      puts current_user
      @entry = Entry.find(params[:id])
      puts @entry
      if !@entry.starred_by.include? current_user
        puts !@entry.starred_by.include?(current_user)
        @entry.starred_by << current_user
        puts @entry.starred_by
        redirect_to current_user
      else
        redirect_to :back
      end
    else
      redirect_to current_user
    end
  end

  def unstar
    if current_user
      @entry = Entry.find(params[:id])
      if @entry.starred_by.include? current_user
        UserStar.where(user_id: current_user.id, entry_id: @entry.id).first.destroy
        redirect_to current_user
      else
        redirect_to :back
      end
    else
      redirect_to root_path
    end
  end
end