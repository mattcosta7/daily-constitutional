require 'net/http'
require 'json'

class Apis::Weather

  def self.getWeather
    url = "http://api.wunderground.com/api/"+ENV["WEATHER_KEY"]+"/forecast/settings/q/autoip.json"
    response = get_response url
    alter response
  end

  def self.get_response url
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed = JSON.parse(response)
  end

  def self.alter hash
    @weather = hash["forecast"]
    @weather_simple = @weather['simpleforecast']['forecastday'][0]
    @weather_txt = @weather['txt_forecast']['forecastday'][0]
    outputhash = {
      icon: @weather_simple["icon_url"],
      conditions: @weather_simple["conditions"],
      text: @weather_txt["fcttext"],
      pop: @weather_simple["pop"],
      high_temp: @weather_simple["high"]["fahrenheit"],
      low_temp: @weather_simple["low"]["fahrenheit"]
    }
    outputhash
  end

end