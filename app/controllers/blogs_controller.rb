class BlogsController < ApplicationController
  
  def index
    @blogs = Blog.all
  end

  def show
    @blog = Blog.find(params[:id])
    @entries = @blog.entries.all.order(published: :asc)
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.create(blog_params)
    current_user.blogs << @blog
    feed = Feedjira::Feed.fetch_and_parse @blog.url
    feed.entries.first(10).each do |new_entry|
      a = Entry.new(makeEntryHash(new_entry))
      a.save
    end
    redirect_to user_path current_user
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    @blog.update(blog_params)
    redirect_to blog_path(@blog)
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path
  end

  def download_newest_entries
    @blog = Blog.find(params[:id])
    @blog.download_newest_entries!(params[:download_entries][:entries_num].to_i)
    redirect_to blog_path(@blog)
  end

  def update_all_blogs
    Blog.update_all_blogs
    redirect_to blogs_path
  end
  
  private

  def blog_params
    params.require(:blog).permit(:url)
  end

  def makeEntryHash feed
    hash = {title: feed.title,
            url: feed.url,
            author: feed.author,
            content: contentCheck(feed),
            published: feed.published,
            blog_id: @blog.id
          }
    hash
  end

#https://www.alfajango.com/blog/create-a-printable-format-for-any-webpage-with-ruby-and-nokogiri/
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