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
            a = Entry.new(Blog.makeEntryHash(new_entry, @blog.id))
            a.save
          end
          redirect_to :back
        rescue => ex
          flash[:notice]="Only valid RSS Feeds!"
          current_user.blogs.last.destroy
          logger.error ex.message
          redirect_to :back
        end
      else
        redirect_to :back
      end
    else
      if !current_user.blogs.where(blog_params).first
        current_user.blogs << Blog.where(blog_params).first
      end
      redirect_to current_user
    end
  end
  
  private

  def validate!
    if !current_user
      redirect_to root_path
    end
  end

  def blog_params
    params.require(:blog).permit(:url)
  end

end