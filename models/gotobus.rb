class GoToBus

  BASE = "http://search.gotobus.com/search/bus.do?gid=1094144"

  def self.query(origin,destination,date)
    origin = CGI.escape(origin)
    destination = CGI.escape(destination)
    BASE + "&bus_from=#{origin}&bus_to=#{destination}&filter_date=#{date}"
  end


  def self.search(url)
    Nokogiri::HTML(open(url)).css("#listarea tbody tr.hidden-xs")
  end

  def self.schedule(origin,destination,date)
    begin
      url = query(origin,destination,date)
      details = search(url)
      details.collect do |d|
        td = d.css("td")
        price = td[7].text.strip
        {company: "<a href=#{url}>#{td[3].text.strip}</a>",
         departure_time: td[0].text.upcase,
         arrival_time: td[2].text.upcase,
         price: price == "" ? "Unavailable*" : "#{price}.00"}
      end
    rescue
      []
    end
  end

end
