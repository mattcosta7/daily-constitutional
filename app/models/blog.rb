class Blog < ActiveRecord::Base
  has_many :reader_blogs, dependent: :destroy
  has_many :users, through: :reader_blogs
  has_many :entries, dependent: :destroy
  has_many :blogcategories, dependent: :destroy
  has_many :categories, through: :blogcategories
  #http://stackoverflow.com/questions/161738/what-is-the-best-regular-expression-to-check-if-a-string-is-a-valid-url
  VALID_URL_REGEX = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/
  validates :url, presence: true, format: { with: VALID_URL_REGEX },uniqueness:{ case_sensitive: false }

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

#edited from https://www.alfajango.com/blog/create-a-printable-format-for-any-webpage-with-ruby-and-nokogiri/
  def self.contentCheck feed
    require 'open-uri'
    doc = Nokogiri::HTML(open(feed.url)) do |config|
      config.noent.noblanks.noerror
    end
    doc.search("//script","//iframe","//object","//embed","//param","//form","//meta","//link","//title","//nav","//svg","//header").remove
    doc.search("//div","//img","//p","//span","//a","//h1","//h2","//h3","//h4","//h5","//h6","//ul","//ol").attr('class','').attr('id','').attr('style','')
    doc.search('//a').attr('href','#')
    doc.search('//img').attr('class','article-image')
    doc = doc.search("//p","//img").collect{ |p| p.parent }.uniq
    htmlReturn = ''
    doc.each do |x|
      htmlReturn << x.to_xhtml
    end
    htmlReturn
  end

end
