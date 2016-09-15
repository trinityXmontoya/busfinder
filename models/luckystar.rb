class LuckyStar

  BASE = "http://www.luckystarbus.com/SelectSchedule.aspx"
  CODES = { "New York, NY" => 1, "Boston, MA" => 2 }

  def self.schedule(origin,destination,date)
    begin
      schedule = []
      details = search(origin,destination,date)
      puts "Gotdemdetails", details
      # remove the first tr as it is just the table header "Departure Time| Total | Fare"
      details.shift
      details.each do |d|
        text = d.text
        depart = text.scan(/\d{1,2}:\d{2} \w{2}/).first
        price = text.scan(/\$\d{2}.\d{2}/).first
        schedule << {
          company: "<a href=#{BASE}>Lucky Star</a>",
          departure_time: depart,
          arrival_time: "#{add_4hrs(depart)}*" ,
          price: price == nil ? "Unavailable*" : price
        }
      end
      puts "imthesched",schedule
      if schedule == []
        return {error: "No results"}
      else
        return schedule
      end
    rescue
      return {error: "server"}
    end
  end

  def self.search(origin,destination,date)
    opts = {"__EVENTARGUMENT"=>"",
            "__EVENTTARGET"=>"",
            "__EVENTVALIDATION"=>"/wEdADZMJ3qVabL1inXEvKa+wm8IaG2wOEvcJO7kzjj/QzScSdhijYc0x/muySSrOthlZAUovNgXMeDuof7j4bDcmOThFuq0YxdLr4dbUgtiAxrMvLaLWH2R03Og21aLB0JAgBeAm2upkN3eWr7aqLitf2rejrVTguiIeGHGNDEBI8fQjbdczThzqzTlBffGfZ9I4iJdU6YkBiKUYx5z+Jhn5kumPFoRWsN7uizH7HS/oiySpfE9ig9Uu/ZcsKjWoqUWDKCz8Py9Y6bGQ/H5TB8jdqeqvlp7pzWaC5besxr+cPXN90eOYW/p0DvIz8mDC4DIirIavJv0/8lnSOelZ1e+pEGQPs9ahPsZkjavrQCDxd1KvFMQQTcWnmGRI9Y3D4AD7NZjAkxjDLaF/YEmxx8pkikp0dcJfjL23sI5qOHk8L1lxN3EXpsNycLsTDKLev6uqz2XZnALgkk3rzdCK6UbVUWCh1fOr9emNqDLYoYyI6QNHc3zJwX3Blr/a2Ns8h6ru3bcpIsbqxWo1cZkHfMq+wz88NmCU9+f/gK3LSYmEBX7MYp5GY0hq++fweO9VjobB9jqIaQqf1B+7RnrCZQQftxWWZS4wB+QHY0xdkLpUcFmOlcRv/FwkW8Imk353DNI9Z1glAmSF9o+MJge2VVeUEDXu4eFfyc8iYTDKiAzOgYGZ2SBpSNKU8J+PVBLFGKlhcs6g8fVng5g3rkLdJEqlxVGYT3bXf7Dtj//TzkYvaD0Q+Dpa07YnRshk2cZjuSbgMzp/yJE8K1Cjfxn5hCwDOljGgHXo/P/clHBgZWuAaCIe5TbxTMOs/B5vIdEx4y13aBxwkgdWMTW3/5zOjGiLw2JRWaE+kvfwH+74u7dlPDFcm5QwZ3Ya/cmoRWt+1GrQGE1cSJZQTx9NZ51d58E9V2eqXN7mLIi5f6v1Qb8fjrI3uG1kYZlARbsM8IYLtcuQj9UuqlD0FB5ysr/1KlJAF2pwZIMdrMfiAPKcrU18cd6Zz4NCt8rozqfDBFzT18BUCCcYEvtSl4ChgNkl7BTnKuJGBFJeRTdN/nEk6eYFv95d0PiylQgLr0Y1Of1Rzu+sVHkpLmZQSCXBMr2UV75mBXfGJO8q6fm+VTi8Wh720XM9pQ7WI+Wj8fZP4V+JpaHODRqzeE7pHFCoR4gg5REkSknenuVRQ==",
            "__LASTFOCUS"=>"",
            "__VIEWSTATE"=>"/wEPDwUJMzcyMTg0Mjk0D2QWAmYPZBYCAgMPZBYGAgMPDxYCHgtOYXZpZ2F0ZVVybAUdL1B1cmNoYXNlLmFzcHg/TGFuZ3VhZ2U9ZXMtTVhkZAIGDw8WAh4EVGV4dAXwAjxGT05UIENPTE9SPSMxRjQ1RkMgU0laRT0zPipPbmxpbmUgdGlja2V0cyBtdXN0IGJlIHB1cmNoYXNlZCBhdCBsZWFzdCAxIGhvdXIgYmVmb3JlIHRoZSBkZXBhcnR1cmUgdGltZS4gQW55dGltZSB3aXRoaW4gdGhpcywgeW91IGNhbiBwdXJjaGFzZSBzYW1lIGRheSB0aWNrZXRzIGF0IG91ciBjb3VudGVyKjwvRk9OVD48QlI+DQoNCjxCUj48Rk9OVCBDT0xPUj1GRjAwMDAgU0laRT0zPipEaXNjb3VudCBUaWNrZXRzIGFyZSBzdWJqZWN0IHRvIG91ciBEaXNjb3VudCBUaWNrZXQgUG9saWN5LiBUaWNrZXQgRGF0ZSBhbmQgVGltZSBjYW5ub3QgYmUgY2hhbmdlZCBhZnRlciBwdXJjaGFzZSBhbmQgdGhleSBhcmUgbm9ucmVmdW5kYWJsZSo8L0ZPTlQ+ZGQCBw9kFgwCAQ8QZGQWAQIBZAIFDxBkEBUoATEBMgEzATQBNQE2ATcBOAE5AjEwAjExAjEyAjEzAjE0AjE1AjE2AjE3AjE4AjE5AjIwAjIxAjIyAjIzAjI0AjI1AjI2AjI3AjI4AjI5AjMwAjMxAjMyAjMzAjM0AjM1AjM2AjM3AjM4AjM5AjQwFSgBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTICMTMCMTQCMTUCMTYCMTcCMTgCMTkCMjACMjECMjICMjMCMjQCMjUCMjYCMjcCMjgCMjkCMzACMzECMzICMzMCMzQCMzUCMzYCMzcCMzgCMzkCNDAUKwMoZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2RkAgkPEA8WAh4LXyFEYXRhQm91bmRnZA8WAgIBAgIWAhAFCkJvc3RvbiwgTUEFCkJvc3RvbiwgTUFnEAURTmV3IFlvcmsgQ2l0eSwgTlkFEU5ldyBZb3JrIENpdHksIE5ZZ2RkAg0PEA8WAh8CZ2QQFQERTmV3IFlvcmsgQ2l0eSwgTlkVAQExFCsDAWdkZAIVDw8WCB4JQmFja0NvbG9yCjQfAWUeB0VuYWJsZWRoHgRfIVNCAghkZAIfDw9kDxAWAWYWARYCHg5QYXJhbWV0ZXJWYWx1ZQUKQm9zdG9uLCBNQRYBZmRkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBRZjdGwwMCRNYWluQ29udGVudCRidEdvWCDGZOJ29kONQXrDQ9Pm6FSCMKs=",
            "__VIEWSTATEGENERATOR"=>"C7C53EDD",
            "ctl00$MainContent$btGo.x"=>"54",
            "ctl00$MainContent$btGo.y"=>"23",
            "ctl00$MainContent$ddArrivalCity" => "#{CODES[destination]}",
            "ctl00$MainContent$ddDepartureCity" => "#{origin}",
            "ctl00$MainContent$numPassengers" => "1",
            "ctl00$MainContent$rbFareType" => "Lowest",
            "ctl00$MainContent$rbTripType" => "One",
            "ctl00$MainContent$sd" => "#{convert_date(date)}"}

    clnt = HTTPClient.new
    res = clnt.post(BASE, opts, follow_redirect: true)
    doc = Nokogiri::HTML(res.body)
    return doc.css("table#MainContent_DepartureGrid tr")
  end

  def self.convert_date(date)
    d = date.split('-')
    n_d = "#{d[1]}/#{d[2]}/#{d[0]}"
  end

  def self.add_4hrs(time)
    (Time.parse(time)+14400).strftime("%I:%M%p")
  end

end
