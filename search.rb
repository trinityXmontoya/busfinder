def gotobus
  depart_date = "2014-09-29"
  departure = "Boston,MA"
  origin = "New York, NY"
  url = "http://search.gotobus.com/search/bus.do?option=Select&is_roundtrip=0&submit_flag=submit_flag&roundtrip=0&bus_from=#{departure}&bus_to=#{origin}&filter_date=#{depart_date}&return_date=&adult_num=1"
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
  url = "http://us.megabus.com/JourneyResults.aspx?originCode=123&destinationCode=94&outboundDepartureDate=10%2f18%2f2014&inboundDepartureDate=&passengerCount=1&transportType=0&concessionCount=0&nusCount=0&outboundWheelchairSeated=0&outboundOtherDisabilityCount=0&inboundWheelchairSeated=0&inboundOtherDisabilityCount=0&outboundPcaCount=0&inboundPcaCount=0&promotionCode=&withReturn=0"
  res = Nokogiri::HTML(open(url)).css(".journey")
  details = []
  res.each do |r|
    details << {
      company: "megabus",

      departure_time: r.css('.two p').first.text
                       .gsub!(/\n|\t|\r/,"")
                       .scan(/(?<=Departs)\d{1,2}:\d{2}\S\w{2}/).first,

      arrival_time: r.css('.two p.arrive').first.text
                     .gsub!(/\n|\t|\r/,"")
                     .scan(/(?<=Arrives)\d{1,2}:\d{2}\S\w{2}/).first,

      price: r.css('.five p').text
              .scan(/[$]\d+.\d{2}/).first

    }
  end
  return details
end

def luckystar
  agent = Mechanize.new
  url = "http://www.luckystarbus.com/Purchase.aspx"
  form = agent.get(url).forms.first
  form.radiobuttons_with(value: 'One')[0].check
  form.field_with(name: 'ctl00$MainContent$ddDepartureCity').options[1].select
  form.field_with(name: 'ctl00$MainContent$sd').value = "10/24/2014"
  form.field_with(name: "ctl00$MainContent$ddArrivalCity").value = "New York, NY"
  form.radiobuttons_with(value: 'Lowest')[0].check
  form.click_button
  return agent.current_page.search('body')
end

def peterpan
  url = "https://tds.peterpanbus.com/"
  form = Mechanize.new.get(url).iframes.first.click.forms.first

  #roundtrip
  # 0 for one-way, 1 for roundtrip
  form.radiobuttons_with(name: 'trip:ticketTypeField:ticket-type-border:ticket-type-border_body:ticket-type')[0].check

  #origin
  form.field_with(name: 'trip:origin:fieldFrag:field-border:field-border_body:field-container:field').options.find{|o| o.value == 'BOSTON, MA'}.select

  #destination
  form.field_with(name: 'trip:destination:fieldFrag:field-border:field-border_body:field-container:field').value = "New York, NY"

  #departure date
  form.field_with(name: 'trip:travelDates:dates-border:dates-border_body:departDate:fieldFrag:field-border:field-border_body:field-container:field').value = "2014-10-18"

  page = form.submit
end

def boltbus
  url = "https://www.boltbus.com/"
  agent = Mechanize.new
  page = agent.get(url)
  form = page.forms.first
  form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstRegion$textBox")[0].value = "Northeast"
  form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstOrigin$textBox")[0].value = "Boston South Station - Gate 9 NYC-Gate 10 NWK/PHL"
  form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstDestination$textBox")[0].value = "New York  W 33rd St & 11-12th Ave (DC,BAL,BOS,PHL)"

end





