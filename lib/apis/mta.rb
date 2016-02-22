require 'nokogiri'
require 'open-uri'

class Apis::Mta

  def self.get
    @doc = Nokogiri::XML(open('http://web.mta.info/status/serviceStatus.txt'))
    @trainStatus = []
    for i in 0...9
      @trainStatus.push([@doc.xpath('//name')[i].text,@doc.xpath('//status')[i].text,@doc.xpath('//text')[i]])
    end
    @trainStatus
  end 
end