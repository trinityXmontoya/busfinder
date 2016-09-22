class Megabus

  BASE = "http://us.megabus.com/JourneyResults.aspx?passengerCount=1"

  CODES = {"New York, NY" => 123, "Boston, MA" => 94}

  def self.build_query(origin,destination,date)
    formatted_date = date.strftime("%m-%d-%Y")
    BASE + "&originCode=#{CODES[origin]}"\
           "&destinationCode=#{CODES[destination]}"\
           "&outboundDepartureDate=#{formatted_date}"
  end

  def self.search(url)
    Nokogiri::HTML(open(url)).css(".journey")
  end

  def self.schedule(origin,destination,date)
    url = build_query(origin,destination,date)
    details = search(url)
    details.collect do |d|
      {company: "<a href=#{url}>Megabus</a>",
       departure_time: d.css('.two p').first.text
                        .gsub!(/\n|\t|\r/,"")
                        .scan(/(?<=Departs)\d{1,2}:\d{2}\S\w{2}/).first,
        arrival_time: d.css('.two p.arrive').first.text
                       .gsub!(/\n|\t|\r/,"")
                       .scan(/(?<=Arrives)\d{1,2}:\d{2}\S\w{2}/).first,
        price: d.css('.five p').text
                .scan(/[$]\d+.\d{2}/).first}
    end
  end
  
end
