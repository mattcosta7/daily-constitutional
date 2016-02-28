class BlogsController < ApplicationController
  before_filter :validate!



  def show
    @user = current_user
    @blog = Blog.find(params[:id])
    if @user.blogs.include?(@blog)
      #http://stackoverflow.com/questions/25703360/regular-expression-extract-subdomain-domain
      @title = (/^(?:https?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n]+)/im.match(@blog.url))[1].to_s
      if ((Time.now - @user.weather.updated_at)/60 > 60)
        @user.weather.update_attributes(Apis::Weather.getWeather)
        @user.save
      end
      @geo = Geocoder::search(@user.location)[0]
      @tStatus = User.getTrains(@user)
      @entries = @blog.entries.order(:published).reverse.first(30)
    else
      flash[:notice] = "That's not one of your feeds"
      redirect_to root_path
    end
  end

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
      redirect_to root_path
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