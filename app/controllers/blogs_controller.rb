class BlogsController < ApplicationController


  def new
    @blog = Blog.new
  end

  def create
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
        flash[:notice]="There was an issue with your link, dude!"
        logger.error ex.message
        redirect_to :back
      end
    else
      redirect_to :back
    end
  end
  
  private

  def blog_params
    params.require(:blog).permit(:url)
  end

end