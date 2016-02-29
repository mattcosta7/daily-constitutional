class StatsController < ApplicationController
  def stats
    @users = User.all
    @category = params[:category]
    @blogs = Blog.all
    render layout: false
  end
end
