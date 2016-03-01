class ReaderblogsController < ApplicationController
  before_filter :validate!

  def create
    @user = current_user
    @blog = Blog.find(params[:id])
    if !@user.blogs.include? @blog
      @user.blogs << @blog
    end
    respond_to do |format|
      format.html
      format.js {render blog: @blog}
    end
  end


  private
  def validate!
    if !current_user
      redirect_to root_path
    end
  end
end