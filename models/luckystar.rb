class LuckyStar

  BASE = "http://www.luckystarbus.com/Schedule.aspx"

  def self.search(origin,destination,date)
    formatted_date = date.strftime("%m/%d/%Y")
    url = "#{BASE}?sd=#{formatted_date}"
    clnt = HTTPClient.new
    res = clnt.get(url)
    Nokogiri::HTML(res.body).css("table:contains('to #{destination}') tr")
  end

  def self.add_4hrs(time)
    (Time.parse(time)+14400).strftime("%l:%M%p").strip
  end

  def self.schedule(origin,destination,date)
    details = search(origin,destination,date)
    # remove first trs + last
    details[2...-1].collect do |d|
      td = d.css("td")
      depart = td[0].text
      price = td[1].text
      {company: "<a href='http://www.luckystarbus.com/Purchase.aspx'>Lucky Star</a>",
       departure_time: depart,
       arrival_time: "#{add_4hrs(depart)}*",
       price: price == nil ? "Unavailable*" : price}
    end
  end

end
