class GoToBus

  BASE = "http://search.gotobus.com/search/bus.do?"

  def self.schedule(origin,destination,date)
    schedule = []
    details = search(origin,destination,date)
    details.each do |d|
      td = d.css("tr .n_b_s_se")
      price = td[5].content.strip()
      schedule << {
        company: "gotobus",
        departure_time: td[0].content.upcase,
        arrival_time: td[1].content.upcase,
        price: price == "" ? "Unavailable*" : "#{price}.00"
      }
    end
    return schedule
  end

  def self.search(origin,destination,date)
    origin = CGI.escape(origin)
    destination = CGI.escape(destination)
    q = BASE + "&bus_from=#{origin}&bus_to=#{destination}&filter_date=#{date}"
    return Nokogiri::HTML(open(q)).css("#listarea .b_s_result table")
  end

end
