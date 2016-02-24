class EntriesController < ApplicationController
  before_filter :validate

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

  def unstar
    @entry = Entry.find(params[:id])
    if @entry.starred_by.include? current_user
      UserStar.where(user_id: current_user.id, entry_id: @entry.id).first.destroy
      redirect_to :back
    else
      redirect_to :back
    end
  end

  private 
  def validate
    if !current_user
      redirect_to root_path
    end
  end
end