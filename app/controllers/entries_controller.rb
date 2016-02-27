class EntriesController < ApplicationController
  before_filter :validate

  #place a star on an entry for a user if it isn't already
  def star
    @entry = Entry.find(params[:id])
    puts @entry
    if !@entry.starred_by.include? current_user
      @entry.starred_by << current_user
      redirect_to :back
    else
      redirect_to :back
    end
  end

  #removes the star from the entry if exists
  def unstar
    @entry = Entry.find(params[:id])
    if @entry.starred_by.include? current_user
      UserStar.where(user_id: current_user.id, entry_id: @entry.id).first.destroy
      redirect_to :back
    else
      redirect_to :back
    end
  end

  #ensures a current user
  private 
  def validate
    if !current_user
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end
end