def gotobus
  depart_date = "2014-10-18"
  departure = CGI.escape("Boston, MA")
  origin = CGI.escape("New York, NY")
  url = "http://search.gotobus.com/search/bus.do?option=Select&is_roundtrip=0&submit_flag=submit_flag&roundtrip=0&bus_from=#{departure}&bus_to=#{origin}&filter_date=#{depart_date}&return_date=&adult_num=1"
  details = []
  schedule = Nokogiri::HTML(open(url)).css("#listarea .b_s_result table")
  schedule.each do |s|
    # gotobus doesn't have any more unique class or ids
    td = s.css("tr .n_b_s_se")
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
  schedule = Nokogiri::HTML(open(url)).css(".journey")
  details = []
  schedule.each do |s|
    details << {
      company: "megabus",

      departure_time: s.css('.two p').first.text
                       .gsub!(/\n|\t|\r/,"")
                       .scan(/(?<=Departs)\d{1,2}:\d{2}\S\w{2}/).first,

      arrival_time: s.css('.two p.arrive').first.text
                     .gsub!(/\n|\t|\r/,"")
                     .scan(/(?<=Arrives)\d{1,2}:\d{2}\S\w{2}/).first,

      price: s.css('.five p').text
              .scan(/[$]\d+.\d{2}/).first

    }
  end
  return details
end



def search
  agent = Mechanize.new
  agent.post("http://www.luckystarbus.com/Purchase.aspx", {
    'ctl00$MainContent$rbTripType'=> 'One',
    'ctl00$MainContent$numPassengers'=> '1',
    'ctl00$MainContent$ddDepartureCity'=> 'Boston, MA',
    'ctl00$MainContent$ddArrivalCity'=> '1',
    'ctl00$MainContent$sd'=> '10/17/2014',
    'ctl00$MainContent$rbFareType'=> 'Lowest',
    '__EVENTTARGET'=> 'ctl00$MainContent$rbTripType$1',
    '__EVENTARGUMENT'=> '',
    '__VIEWSTATE'=> '/wEPDwUJMzcyMTg0Mjk0D2QWAmYPZBYCAgMPZBYGAgMPDxYCHgtOYXZpZ2F0ZVVybAUdL1B1cmNoYXNlLmFzcHg/TGFuZ3VhZ2U9ZXMtTVhkZAIGDw8WAh4EVGV4dAXmCDxhIGhyZWY9Ii9wcm9tby9OWW1hcC5wZGYiIHRhcmdldD1fYmxhbms+PHU+PEZPTlQgQ09MT1I9I0ZGMDAwMCBTSVpFPTU+QVRURU5USU9OISEgTkVXIFlPUksgVElDS0VUIENPVU5URVIgTE9DQVRJT04gSEFTIE1PVkVEIFRPIDE0NSBDQU5BTCBTVFJFRVQ8QlI+IA0KPEJSPllvdSBNVVNUIGNoZWNrIGluIGF0IDE0NSBDYW5hbCBTdHJlZXQgYmVmb3JlIGJvYXJkaW5nLiBCdXMgUElDS1VQIGFuZCBEUk9QT0ZGIGxvY2F0aW9uIHJlbWFpbnMgYXQgNTUgQ2hyeXN0aWUgU3QuIFRoYW5rIFlvdSEgLUNsaWNrIEhFUkUgdG8gc2VlIG1hcC48L0ZPTlQ+PC91PjwvYT48QlI+DQo8QlI+PEZPTlQgQ09MT1I9IzRDQzQxNyBTSVpFPTQ+WWVzISBMdWNreSBTdGFyIGlzIG9wZW4gYWdhaW4uIEJ1c2VzIGFyZSBydW5uaW5nIGZyb20gTmV3IFlvcmsgQ2hpbmF0b3duIHRvIEJvc3RvbiBDaGluYXRvd24gYW5kIEJvc3RvbiBDaGluYXRvd24gdG8gTmV3IFlvcmsgQ2hpbmF0b3duLjxCUj4gDQo8QlI+UGxlYXNlIHNlZSBvdXIgc2NoZWR1bGVzIGFuZCBib29rIHRpY2tldHMgb25saW5lLjwvRk9OVD48QlI+DQoNCjxCUj48Rk9OVCBDT0xPUj0jNzM2QUZGIFNJWkU9Mz5PdXIgTmV3IFlvcmsgbG9jYXRpb24gaGFzIGZyZWUgV0lGSSBhbmQgb3V0bGV0cyB0byBjaGFyZ2UgeW91ciBtb2JpbGUgZGV2aWNlcy4gV2UgYWxzbyBoYXZlIGEgVFYgc28geW91IGNhbiBjYXRjaCB1cCBvbiB0aGUgbGF0ZXN0IG5ld3MhPC9GT05UPjxCUj4NCiANCjxCUj48Rk9OVCBDT0xPUj0jMUY0NUZDIFNJWkU9Mz4qT25saW5lIHRpY2tldHMgbXVzdCBiZSBwdXJjaGFzZWQgYXQgbGVhc3QgMSBob3VyIGJlZm9yZSB0aGUgZGVwYXJ0dXJlIHRpbWUuIEFueXRpbWUgd2l0aGluIHRoaXMsIHlvdSBjYW4gcHVyY2hhc2Ugc2FtZSBkYXkgdGlja2V0cyBhdCBvdXIgY291bnRlcio8L0ZPTlQ+PEJSPg0KDQo8QlI+PEZPTlQgQ09MT1I9RkYwMDAwIFNJWkU9Mz4qRGlzY291bnQgVGlja2V0cyBhcmUgc3ViamVjdCB0byBvdXIgRGlzY291bnQgVGlja2V0IFBvbGljeS4gVGlja2V0IERhdGUgYW5kIFRpbWUgY2Fubm90IGJlIGNoYW5nZWQgYWZ0ZXIgcHVyY2hhc2UgYW5kIHRoZXkgYXJlIG5vbnJlZnVuZGFibGUqPC9GT05UPg0KDQpkZAIHD2QWDAIBDxBkZBYAZAIFDxBkEBUoATEBMgEzATQBNQE2ATcBOAE5AjEwAjExAjEyAjEzAjE0AjE1AjE2AjE3AjE4AjE5AjIwAjIxAjIyAjIzAjI0AjI1AjI2AjI3AjI4AjI5AjMwAjMxAjMyAjMzAjM0AjM1AjM2AjM3AjM4AjM5AjQwFSgBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTICMTMCMTQCMTUCMTYCMTcCMTgCMTkCMjACMjECMjICMjMCMjQCMjUCMjYCMjcCMjgCMjkCMzACMzECMzICMzMCMzQCMzUCMzYCMzcCMzgCMzkCNDAUKwMoZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2RkAgkPEA8WAh4LXyFEYXRhQm91bmRnZA8WAgIBAgIWAhAFCkJvc3RvbiwgTUEFCkJvc3RvbiwgTUFnEAURTmV3IFlvcmsgQ2l0eSwgTlkFEU5ldyBZb3JrIENpdHksIE5ZZ2RkAg0PEA8WAh8CZ2QQFQERTmV3IFlvcmsgQ2l0eSwgTlkVAQExFCsDAWdkZAIVDw8WCB4JQmFja0NvbG9yCjQfAWUeB0VuYWJsZWRoHgRfIVNCAghkZAIfDw9kDxAWAWYWARYCHg5QYXJhbWV0ZXJWYWx1ZQUKQm9zdG9uLCBNQRYBZmRkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBRZjdGwwMCRNYWluQ29udGVudCRidEdvwbhqhkFFsrlXS0S0mNHMfZU317w=',
    '__EVENTVALIDATION'=> '/wEWNwKf77e6AwLuseWwCgLV3sKgCwKn3JGKDQLJj5y8CgLIj5y8CgLLj5y8CgLKj5y8CgLNj5y8CgLMj5y8CgLPj5y8CgLej5y8CgLRj5y8CgLJj9y/CgLJj9C/CgLJj9S/CgLJj+i/CgLJj+y/CgLJj+C/CgLJj+S/CgLJj/i/CgLJj7y8CgLJj7C8CgLIj9y/CgLIj9C/CgLIj9S/CgLIj+i/CgLIj+y/CgLIj+C/CgLIj+S/CgLIj/i/CgLIj7y8CgLIj7C8CgLLj9y/CgLLj9C/CgLLj9S/CgLLj+i/CgLLj+y/CgLLj+C/CgLLj+S/CgLLj/i/CgLLj7y8CgLLj7C8CgLKj9y/CgKEqZSECQKEqZSECQKu98XRCAKppL+gBwKztP72DgKw7NHHAgLe4cH0AgLmvYqoAgLczuTwCAKkgd7NDALA6+GiC9RzJOOGhIrLnJW1ydqt1vZKIsKV',
    'ctl00$MainContent$btGo.x'=> 0,
    'ctl00$MainContent$btGo.y'=> 0
      })
end

def luckystar
  agent = Mechanize.new
  url = "http://www.luckystarbus.com"
  page = agent.get(url)
  form = page.form("aspnetForm")
  form['ctl00$MainContent$rbTripType'] = 'One'
  form['ctl00$MainContent$numPassengers'] = '1'
  form['ctl00$MainContent$ddDepartureCity'] = 'Boston, MA'
  form['ctl00$MainContent$ddArrivalCity'] = '1'
  form['ctl00$MainContent$sd'] = '10/17/2014'
  form['ctl00$MainContent$rbFareType'] = 'Lowest'
  form['__EVENTTARGET'] = 'ctl00$MainContent$rbTripType$1'
  form['__EVENTARGUMENT'] = ''
  form['__VIEWSTATE'] = '/wEPDwUJMzcyMTg0Mjk0D2QWAmYPZBYCAgMPZBYGAgMPDxYCHgtOYXZpZ2F0ZVVybAUdL1B1cmNoYXNlLmFzcHg/TGFuZ3VhZ2U9ZXMtTVhkZAIGDw8WAh4EVGV4dAXmCDxhIGhyZWY9Ii9wcm9tby9OWW1hcC5wZGYiIHRhcmdldD1fYmxhbms+PHU+PEZPTlQgQ09MT1I9I0ZGMDAwMCBTSVpFPTU+QVRURU5USU9OISEgTkVXIFlPUksgVElDS0VUIENPVU5URVIgTE9DQVRJT04gSEFTIE1PVkVEIFRPIDE0NSBDQU5BTCBTVFJFRVQ8QlI+IA0KPEJSPllvdSBNVVNUIGNoZWNrIGluIGF0IDE0NSBDYW5hbCBTdHJlZXQgYmVmb3JlIGJvYXJkaW5nLiBCdXMgUElDS1VQIGFuZCBEUk9QT0ZGIGxvY2F0aW9uIHJlbWFpbnMgYXQgNTUgQ2hyeXN0aWUgU3QuIFRoYW5rIFlvdSEgLUNsaWNrIEhFUkUgdG8gc2VlIG1hcC48L0ZPTlQ+PC91PjwvYT48QlI+DQo8QlI+PEZPTlQgQ09MT1I9IzRDQzQxNyBTSVpFPTQ+WWVzISBMdWNreSBTdGFyIGlzIG9wZW4gYWdhaW4uIEJ1c2VzIGFyZSBydW5uaW5nIGZyb20gTmV3IFlvcmsgQ2hpbmF0b3duIHRvIEJvc3RvbiBDaGluYXRvd24gYW5kIEJvc3RvbiBDaGluYXRvd24gdG8gTmV3IFlvcmsgQ2hpbmF0b3duLjxCUj4gDQo8QlI+UGxlYXNlIHNlZSBvdXIgc2NoZWR1bGVzIGFuZCBib29rIHRpY2tldHMgb25saW5lLjwvRk9OVD48QlI+DQoNCjxCUj48Rk9OVCBDT0xPUj0jNzM2QUZGIFNJWkU9Mz5PdXIgTmV3IFlvcmsgbG9jYXRpb24gaGFzIGZyZWUgV0lGSSBhbmQgb3V0bGV0cyB0byBjaGFyZ2UgeW91ciBtb2JpbGUgZGV2aWNlcy4gV2UgYWxzbyBoYXZlIGEgVFYgc28geW91IGNhbiBjYXRjaCB1cCBvbiB0aGUgbGF0ZXN0IG5ld3MhPC9GT05UPjxCUj4NCiANCjxCUj48Rk9OVCBDT0xPUj0jMUY0NUZDIFNJWkU9Mz4qT25saW5lIHRpY2tldHMgbXVzdCBiZSBwdXJjaGFzZWQgYXQgbGVhc3QgMSBob3VyIGJlZm9yZSB0aGUgZGVwYXJ0dXJlIHRpbWUuIEFueXRpbWUgd2l0aGluIHRoaXMsIHlvdSBjYW4gcHVyY2hhc2Ugc2FtZSBkYXkgdGlja2V0cyBhdCBvdXIgY291bnRlcio8L0ZPTlQ+PEJSPg0KDQo8QlI+PEZPTlQgQ09MT1I9RkYwMDAwIFNJWkU9Mz4qRGlzY291bnQgVGlja2V0cyBhcmUgc3ViamVjdCB0byBvdXIgRGlzY291bnQgVGlja2V0IFBvbGljeS4gVGlja2V0IERhdGUgYW5kIFRpbWUgY2Fubm90IGJlIGNoYW5nZWQgYWZ0ZXIgcHVyY2hhc2UgYW5kIHRoZXkgYXJlIG5vbnJlZnVuZGFibGUqPC9GT05UPg0KDQpkZAIHD2QWDAIBDxBkZBYAZAIFDxBkEBUoATEBMgEzATQBNQE2ATcBOAE5AjEwAjExAjEyAjEzAjE0AjE1AjE2AjE3AjE4AjE5AjIwAjIxAjIyAjIzAjI0AjI1AjI2AjI3AjI4AjI5AjMwAjMxAjMyAjMzAjM0AjM1AjM2AjM3AjM4AjM5AjQwFSgBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTICMTMCMTQCMTUCMTYCMTcCMTgCMTkCMjACMjECMjICMjMCMjQCMjUCMjYCMjcCMjgCMjkCMzACMzECMzICMzMCMzQCMzUCMzYCMzcCMzgCMzkCNDAUKwMoZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2RkAgkPEA8WAh4LXyFEYXRhQm91bmRnZA8WAgIBAgIWAhAFCkJvc3RvbiwgTUEFCkJvc3RvbiwgTUFnEAURTmV3IFlvcmsgQ2l0eSwgTlkFEU5ldyBZb3JrIENpdHksIE5ZZ2RkAg0PEA8WAh8CZ2QQFQERTmV3IFlvcmsgQ2l0eSwgTlkVAQExFCsDAWdkZAIVDw8WCB4JQmFja0NvbG9yCjQfAWUeB0VuYWJsZWRoHgRfIVNCAghkZAIfDw9kDxAWAWYWARYCHg5QYXJhbWV0ZXJWYWx1ZQUKQm9zdG9uLCBNQRYBZmRkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBRZjdGwwMCRNYWluQ29udGVudCRidEdvwbhqhkFFsrlXS0S0mNHMfZU317w='
  form['__EVENTVALIDATION'] = '/wEWNwKf77e6AwLuseWwCgLV3sKgCwKn3JGKDQLJj5y8CgLIj5y8CgLLj5y8CgLKj5y8CgLNj5y8CgLMj5y8CgLPj5y8CgLej5y8CgLRj5y8CgLJj9y/CgLJj9C/CgLJj9S/CgLJj+i/CgLJj+y/CgLJj+C/CgLJj+S/CgLJj/i/CgLJj7y8CgLJj7C8CgLIj9y/CgLIj9C/CgLIj9S/CgLIj+i/CgLIj+y/CgLIj+C/CgLIj+S/CgLIj/i/CgLIj7y8CgLIj7C8CgLLj9y/CgLLj9C/CgLLj9S/CgLLj+i/CgLLj+y/CgLLj+C/CgLLj+S/CgLLj/i/CgLLj7y8CgLLj7C8CgLKj9y/CgKEqZSECQKEqZSECQKu98XRCAKppL+gBwKztP72DgKw7NHHAgLe4cH0AgLmvYqoAgLczuTwCAKkgd7NDALA6+GiC9RzJOOGhIrLnJW1ydqt1vZKIsKV'
  form['ctl00$MainContent$btGo.x'] = 0
  form['ctl00$MainContent$btGo.y'] = 0

  schedule = form.submit.search('#ctl00_MainContent_DepartureGrid tr')
  # remove the first tr as it is just the table header "Departure Time| Total | Fare"
  schedule.shift

  details = []
  schedule.each do |s|
    depart = s.text.scan(/\d{1,2}:\d{2} \w{2}/).first
    details << {
      company: "luckystar",
      departure_time: depart,
      arrival_time: "#{add_4hours_30mins(depart)}*" ,
      price: s.text.scan(/\$\d{2}.\d{2}/).first
    }
  end
  return details
end



def peterpan
  b = Watir::Browser.new :phantomjs
  url = "https://tds.peterpanbus.com/"
  b.goto(url)
  form = b.iframe(id: 'frame-one')
  #oneway
  form.radio(value: "radio13").set
  #roundtrip
  # b.radio(value: 'radio16').set

  form.select_list(name: "trip:origin:fieldFrag:field-border:field-border_body:field-container:field").select("Boston, MA")
  form.text_field(name: 'trip:destination:fieldFrag:field-border:field-border_body:field-container:field').set('New York, NY')
  form.text_field(name: 'trip:travelDates:dates-border:dates-border_body:departDate:fieldFrag:field-border:field-border_body:field-container:field').set('2014-10-18')
  form.button(type: 'submit').click
  schedule = b.iframe(id: 'frame-one').ul(class: 'schedule-list').when_present.text
  details = []
  schedule.split("\nView Schedule Stops\nSelect\n").each do |s|
    dets = s.split("\n")
    details << {
      company: "peterpan",
      departure_time: dets[0],
      arrival_time: dets[1],
      price: dets[3]
    }
  end
  return details
end

def boltbus
  url = "https://www.boltbus.com/"
  agent = Mechanize.new
  page = agent.get(url, [], nil, {'User-agent'=>'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1'})
  form = page.forms.first

  form['__EVENTTARGET']='ctl00$cphM$forwardRouteUC$lstRegion$repeater$ctl01$link'
  form['__EVENTARGUMENT']=''
  form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstRegion$textBox")[0].value = "Northeast"

  form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstOrigin$textBox")[0].value = "Boston South Station - Gate 9 NYC-Gate 10 NWK/PHL"
  form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstDestination$textBox")[0].value = "New York  W 33rd St & 11-12th Ave (DC,BAL,BOS,PHL)"
  return 'dog'
  # b = Watir::Browser.new :phantomjs
  # b.goto url
  # b.

end


# not proper naming but short, readable, and understandable! does that make it proper?....
def add_4hours_30mins(time)
  (Time.parse(time)+16200).strftime("%I:%M%p")
end


