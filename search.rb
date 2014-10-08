def gotobus
  url = "http://search.gotobus.com/search/bus.do?option=Select&is_roundtrip=0&submit_flag=submit_flag&roundtrip=0&bus_from=Boston%2C+MA&bus_to=New+York%2C+NY&filter_date=2014-10-08&return_date=&adult_num=1"
  details = []
  table = Nokogiri::HTML(open(url)).css("#listarea .b_s_result table")
  table.each do |t|
    # gotobus doesn't have any more unique class or ids
    td = t.css("tr .n_b_s_se")
    details << {
      company: "gotobus",
      departure_time: td[0].content,
      arrival_time: td[1].content,
      price: td[5].content.strip()
    }
  end
  return details
end

def megabus
  url = "http://us.megabus.com/JourneyResults.aspx?originCode=123&destinationCode=94&outboundDepartureDate=10%2f9%2f2014&inboundDepartureDate=&passengerCount=1&transportType=0&concessionCount=0&nusCount=0&outboundWheelchairSeated=0&outboundOtherDisabilityCount=0&inboundWheelchairSeated=0&inboundOtherDisabilityCount=0&outboundPcaCount=0&inboundPcaCount=0&promotionCode=&withReturn=0"
  res = Nokogiri::HTML(open(url)).css(".journey")
  details = []
  res.each do |r|
    details << {
      company: "megabus",
      departure_time: r.css('.two p').first.text.gsub!(/\n|\t|\r/,"").scan(/(?<=Departs)\d{1,2}:\d{2}\S\w{2}/).first,
      arrival_time: r.css('.two p.arrive').first.text.gsub!(/\n|\t|\r/,"").scan(/(?<=Arrives)\d{1,2}:\d{2}\S\w{2}/).first,
      price: r.css('.five p').text.scan(/[$]\d+.\d{2}/).first
    }
  end
  return details
end

# def peterpan
#   url = "https://tds.peterpanbus.com/"
#   form = Mechanize.new.get(url).iframes.first.click.forms.first
#   fields = form.fields

#   #destination city
#   fields[1].value = destination

#   #travel dates dates
#   fields[2].value = departure_date

#   # origin
#   fields[3].value = origin

#   page = form.submit
# end





