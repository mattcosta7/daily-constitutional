class BlogsController < ApplicationController
  before_filter :validate!

#new blogs can be created, parse the url, if error say so, otherwise make entries
#if not a new blog, just find the blog in question and append to that user
  def create
    if !Blog.where(blog_params).first
      @blog = Blog.new(blog_params)
      if @blog.save
        current_user.blogs << @blog
        begin
          feed = Feedjira::Feed.fetch_and_parse @blog.url
          feed.entries.first(10).each do |new_entry|
            db_entry = Entry.new(Blog.makeEntryHash(new_entry, @blog.id))
            db_entry.save
          end
          flash[:notice]="Added Blog"
          redirect_to :back
        rescue => ex
          flash[:notice]="Only valid RSS Feeds!<br><span id='spot2'><a href='mailto:matt+dailyC@mattc.io' target='_blank'>Favorite feed not working?</a></span>"
          current_user.blogs.last.destroy
          logger.error ex.message
          redirect_to :back
        end
      else
        flash[:notice]="Only valid RSS Feeds!<br><span id='spot2'><a href='mailto:matt+dailyC@mattc.io' target='_blank'>Favorite feed not working?</a></span>"
        redirect_to :back
      end
    else
      if !current_user.blogs.where(blog_params).first
        current_user.blogs << Blog.where(blog_params).first
      end
      flash[:notice]="Added Blog"
      redirect_to current_user
    end
  end
  
  private

  def validate!
    if !current_user
      flash[:notice]="Sign In Already!"
      redirect_to root_path
    end
  end

  def blog_params
    params.require(:blog).permit(:url)
  end

end