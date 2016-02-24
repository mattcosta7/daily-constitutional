class SessionsController < ApplicationController

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      @user.location = request.remote_ip
      @user.save
      @user.blogs.each do |blog|
        feed = Feedjira::Feed.fetch_and_parse(blog.url)
        feed.entries.first(10).each do |new_entry|
          if !Entry.where(url: new_entry.url).first
            puts new_entry
            a = Entry.new(Blog.makeEntryHash(new_entry, blog))
            a.save
            puts a
          end
        end
      end
      if ((Time.now - @user.weather.updated_at)/60 > 60)
        @user.weather.update_attributes(Apis::Weather.getWeather)
      end
      session[:user_id] = @user.id 
      flash[:notice]="signed in"
      redirect_to current_user
    else
      flash[:notice]="sign in failed"
      redirect_to :back
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end


  private
  def makeEntryHash feed, blog
    hash = {title: feed.title,
            url: feed.url,
            author: feed.author,
            content: contentCheck(feed),
            published: feed.published,
            blog_id: blog.id
          }
    hash
  end

  def contentCheck feed
    require 'open-uri'
    doc = Nokogiri::HTML(open(feed.url)) do |config|
      config.noent.noblanks.noerror
    end
    doc.search("//script","//img","//iframe","//object","//embed","//param","//form","//meta","//link","//title").remove
    doc.search("//div","//p","//span","//a","//h1","//h2","//h3","//h4","//h5","//h6","//ul","//ol").attr('class','').attr('id','').attr('style','')
    doc = doc.search("//p").collect{ |p| p.parent }.uniq
    htmlReturn = ''
    doc.each do |x|
      htmlReturn << x.to_xhtml
    end
    htmlReturn
  end
end
