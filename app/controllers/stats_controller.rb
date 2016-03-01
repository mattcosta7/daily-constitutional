class StatsController < ApplicationController
  def stats
    @users = User.all
    @categories = Category.all
    @blogs = Blog.all
    render layout: false
  end
end


