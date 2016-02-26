class Blog < ActiveRecord::Base
  has_many :reader_blogs, dependent: :destroy
  has_many :users, through: :reader_blogs
  has_many :entries, dependent: :destroy

  def self.update_all_entries
    Blog.all.each do |blog|
      begin
        feed = Feedjira::Feed.fetch_and_parse blog.url
        feed.entries.first(10).each do |new_entry|
          if !Entry.where(url: new_entry.url).first
            a = Entry.new(Blog.makeEntryHash(new_entry, blog.id))
            a.save
          end
        end
      rescue => ex
        puts "Error, yo, #{ex}"
      end
    end
  end

  def self.makeEntryHash feed, id
    hash = {
      title: feed.title,
      url: feed.url,
      author: feed.author,
      content: Blog.contentCheck(feed),
      published: feed.published,
      blog_id: id
    }
    hash
  end

#https://www.alfajango.com/blog/create-a-printable-format-for-any-webpage-with-ruby-and-nokogiri/
  def self.contentCheck feed
    require 'open-uri'
    doc = Nokogiri::HTML(open(feed.url)) do |config|
      config.noent.noblanks.noerror
    end
    doc.search("//script","//article","//iframe","//object","//embed","//param","//form","//meta","//link","//title","//img").remove
    doc.search("//*").attr('class','').attr('id','').attr('style','')
    doc.search('//a').attr('target','_blank')
    # doc.search('//img').attr('class','article-image')
    doc = doc.search("//p").collect{ |p| p.parent }.uniq
    htmlReturn = ''
    doc.each do |x|
      htmlReturn << x.to_xhtml
    end
    htmlReturn
  end

end
