class LuckyStar

  BASE = "http://www.luckystarbus.com/Purchase.aspx"
  CODES = { "New York, NY" => 1, "Boston, MA" => 2 }

  def self.schedule(origin,destination,date)
    schedule = []
    details = search(origin,destination,date)
    # remove the first tr as it is just the table header "Departure Time| Total | Fare"
    details.shift
    details.each do |d|
      depart = d.text.scan(/\d{1,2}:\d{2} \w{2}/).first
      price = d.text.scan(/\$\d{2}.\d{2}/).first
      schedule << {
        company: "<a href=#{BASE}>Lucky Star</a>",
        departure_time: depart,
        arrival_time: "#{add_4hours_30mins(depart)}*" ,
        price: price == nil ? "Unavailable*" : price
      }
    end
    return schedule
  end

  def self.search(origin,destination,date)
    agent = Mechanize.new
    res = agent.post(BASE, {
      'ctl00$MainContent$rbTripType'=> 'One',
      'ctl00$MainContent$numPassengers'=> '1',
      'ctl00$MainContent$ddDepartureCity'=> "#{origin}",
      'ctl00$MainContent$ddArrivalCity'=> "#{CODES[destination]}",
      'ctl00$MainContent$sd'=> "#{convert_date(date)}",
      'ctl00$MainContent$rbFareType'=> 'Lowest',
      '__EVENTTARGET'=> 'ctl00$MainContent$rbTripType$1',
      '__EVENTARGUMENT'=> '',
      '__VIEWSTATE'=> '/wEPDwUJMzcyMTg0Mjk0D2QWAmYPZBYCAgMPZBYGAgMPDxYCHgtOYXZpZ2F0ZVVybAUdL1B1cmNoYXNlLmFzcHg/TGFuZ3VhZ2U9ZXMtTVhkZAIGDw8WAh4EVGV4dAXmCDxhIGhyZWY9Ii9wcm9tby9OWW1hcC5wZGYiIHRhcmdldD1fYmxhbms+PHU+PEZPTlQgQ09MT1I9I0ZGMDAwMCBTSVpFPTU+QVRURU5USU9OISEgTkVXIFlPUksgVElDS0VUIENPVU5URVIgTE9DQVRJT04gSEFTIE1PVkVEIFRPIDE0NSBDQU5BTCBTVFJFRVQ8QlI+IA0KPEJSPllvdSBNVVNUIGNoZWNrIGluIGF0IDE0NSBDYW5hbCBTdHJlZXQgYmVmb3JlIGJvYXJkaW5nLiBCdXMgUElDS1VQIGFuZCBEUk9QT0ZGIGxvY2F0aW9uIHJlbWFpbnMgYXQgNTUgQ2hyeXN0aWUgU3QuIFRoYW5rIFlvdSEgLUNsaWNrIEhFUkUgdG8gc2VlIG1hcC48L0ZPTlQ+PC91PjwvYT48QlI+DQo8QlI+PEZPTlQgQ09MT1I9IzRDQzQxNyBTSVpFPTQ+WWVzISBMdWNreSBTdGFyIGlzIG9wZW4gYWdhaW4uIEJ1c2VzIGFyZSBydW5uaW5nIGZyb20gTmV3IFlvcmsgQ2hpbmF0b3duIHRvIEJvc3RvbiBDaGluYXRvd24gYW5kIEJvc3RvbiBDaGluYXRvd24gdG8gTmV3IFlvcmsgQ2hpbmF0b3duLjxCUj4gDQo8QlI+UGxlYXNlIHNlZSBvdXIgc2NoZWR1bGVzIGFuZCBib29rIHRpY2tldHMgb25saW5lLjwvRk9OVD48QlI+DQoNCjxCUj48Rk9OVCBDT0xPUj0jNzM2QUZGIFNJWkU9Mz5PdXIgTmV3IFlvcmsgbG9jYXRpb24gaGFzIGZyZWUgV0lGSSBhbmQgb3V0bGV0cyB0byBjaGFyZ2UgeW91ciBtb2JpbGUgZGV2aWNlcy4gV2UgYWxzbyBoYXZlIGEgVFYgc28geW91IGNhbiBjYXRjaCB1cCBvbiB0aGUgbGF0ZXN0IG5ld3MhPC9GT05UPjxCUj4NCiANCjxCUj48Rk9OVCBDT0xPUj0jMUY0NUZDIFNJWkU9Mz4qT25saW5lIHRpY2tldHMgbXVzdCBiZSBwdXJjaGFzZWQgYXQgbGVhc3QgMSBob3VyIGJlZm9yZSB0aGUgZGVwYXJ0dXJlIHRpbWUuIEFueXRpbWUgd2l0aGluIHRoaXMsIHlvdSBjYW4gcHVyY2hhc2Ugc2FtZSBkYXkgdGlja2V0cyBhdCBvdXIgY291bnRlcio8L0ZPTlQ+PEJSPg0KDQo8QlI+PEZPTlQgQ09MT1I9RkYwMDAwIFNJWkU9Mz4qRGlzY291bnQgVGlja2V0cyBhcmUgc3ViamVjdCB0byBvdXIgRGlzY291bnQgVGlja2V0IFBvbGljeS4gVGlja2V0IERhdGUgYW5kIFRpbWUgY2Fubm90IGJlIGNoYW5nZWQgYWZ0ZXIgcHVyY2hhc2UgYW5kIHRoZXkgYXJlIG5vbnJlZnVuZGFibGUqPC9GT05UPg0KDQpkZAIHD2QWDAIBDxBkZBYAZAIFDxBkEBUoATEBMgEzATQBNQE2ATcBOAE5AjEwAjExAjEyAjEzAjE0AjE1AjE2AjE3AjE4AjE5AjIwAjIxAjIyAjIzAjI0AjI1AjI2AjI3AjI4AjI5AjMwAjMxAjMyAjMzAjM0AjM1AjM2AjM3AjM4AjM5AjQwFSgBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTICMTMCMTQCMTUCMTYCMTcCMTgCMTkCMjACMjECMjICMjMCMjQCMjUCMjYCMjcCMjgCMjkCMzACMzECMzICMzMCMzQCMzUCMzYCMzcCMzgCMzkCNDAUKwMoZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2RkAgkPEA8WAh4LXyFEYXRhQm91bmRnZA8WAgIBAgIWAhAFCkJvc3RvbiwgTUEFCkJvc3RvbiwgTUFnEAURTmV3IFlvcmsgQ2l0eSwgTlkFEU5ldyBZb3JrIENpdHksIE5ZZ2RkAg0PEA8WAh8CZ2QQFQERTmV3IFlvcmsgQ2l0eSwgTlkVAQExFCsDAWdkZAIVDw8WCB4JQmFja0NvbG9yCjQfAWUeB0VuYWJsZWRoHgRfIVNCAghkZAIfDw9kDxAWAWYWARYCHg5QYXJhbWV0ZXJWYWx1ZQUKQm9zdG9uLCBNQRYBZmRkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBRZjdGwwMCRNYWluQ29udGVudCRidEdvwbhqhkFFsrlXS0S0mNHMfZU317w=',
      '__EVENTVALIDATION'=> '/wEWNwKf77e6AwLuseWwCgLV3sKgCwKn3JGKDQLJj5y8CgLIj5y8CgLLj5y8CgLKj5y8CgLNj5y8CgLMj5y8CgLPj5y8CgLej5y8CgLRj5y8CgLJj9y/CgLJj9C/CgLJj9S/CgLJj+i/CgLJj+y/CgLJj+C/CgLJj+S/CgLJj/i/CgLJj7y8CgLJj7C8CgLIj9y/CgLIj9C/CgLIj9S/CgLIj+i/CgLIj+y/CgLIj+C/CgLIj+S/CgLIj/i/CgLIj7y8CgLIj7C8CgLLj9y/CgLLj9C/CgLLj9S/CgLLj+i/CgLLj+y/CgLLj+C/CgLLj+S/CgLLj/i/CgLLj7y8CgLLj7C8CgLKj9y/CgKEqZSECQKEqZSECQKu98XRCAKppL+gBwKztP72DgKw7NHHAgLe4cH0AgLmvYqoAgLczuTwCAKkgd7NDALA6+GiC9RzJOOGhIrLnJW1ydqt1vZKIsKV',
      'ctl00$MainContent$btGo.x'=> 0,
      'ctl00$MainContent$btGo.y'=> 0
        })
    return res.search('#ctl00_MainContent_DepartureGrid tr')
  end

  def self.convert_date(date)
    d = date.split('-')
    n_d = "#{d[1]}/#{d[2]}/#{d[0]}"
  end

  def self.add_4hours_30mins(time)
    (Time.parse(time)+16200).strftime("%I:%M%p")
  end

end
