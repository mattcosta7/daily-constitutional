require 'nokogiri'
require 'open-uri'

class Apis::Mta

  def self.getNyc
    @doc = Nokogiri::XML(open('http://web.mta.info/status/serviceStatus.txt'))
    @trainStatus = []
    for i in 0...9
      @trainStatus.push([
        #image
        @doc.xpath('//name')[i].text+'.gif',
        #status
        @doc.xpath('//status')[i].text,
        #error
        @doc.xpath('//text')[i].text])
    end
    @trainStatus
  end 


  def self.getWdc
    doc = Nokogiri::HTML.parse(open('http://www.wmata.com/index.cfm?forcedesktop=1'))
    @trainStatus = []
    for i in 0...6
      @trainStatus.push([
        #image
        doc.search('.first')[i*4].children[0].attributes['src'].value[11..100],
        #status
        doc.search('.first')[i*4+3].text.gsub(/[^0-9a-z]/i, '')  == "OnTime" ? "GOOD SERVICE" : "DELAYS",
        #error
        doc.search('.first')[i*4+3].text.gsub(/[^0-9a-z]/i, '')  != "OnTime" ? doc.search('.first')[i*4+3].text : ""
      ])
    end
    @trainStatus
  end

  def self.getChicago
    doc = Nokogiri::HTML.parse(open('http://www.transitchicago.com/'))
    @trainStatus = []
    for i in 0...8
      @trainStatus.push([
      #image
      doc.search('.tblsystatus').children[i*2+1].children[1].text.gsub(/[^0-9a-z]/i, '')+'_chic.png',
      #status
      doc.search('.tblsystatus').children[i*2+1].children[3].text.gsub(/[^0-9a-z]/i, '')  == "NormalService" ? "GOOD SERVICE" : "DELAYS",
      #error
      "Not yet available"
      #error
      ])
    end
    @trainStatus
  end
end





