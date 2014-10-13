class GoToBus

  BASE = "http://search.gotobus.com/search/bus.do?"

  def self.schedule(origin,destination,date)
    schedule = []
    url = query(origin,destination,date)
    details = search(url)
    details.each do |d|
      td = d.css("tr .n_b_s_se")
      price = td[5].content.strip()
      schedule << {
        company: "<a href=#{url}>GoToBus</a>",
        departure_time: td[0].content.upcase,
        arrival_time: td[1].content.upcase,
        price: price == "" ? "Unavailable*" : "#{price}.00"
      }
    end
    return schedule
  end

  def self.query(origin,destination,date)
    origin = CGI.escape(origin)
    destination = CGI.escape(destination)
    return BASE + "&bus_from=#{origin}&bus_to=#{destination}&filter_date=#{date}"
  end

  def self.search(url)
    return Nokogiri::HTML(open(url)).css("#listarea .b_s_result table")
  end

end
