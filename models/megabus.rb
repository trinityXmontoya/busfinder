class Megabus

  BASE = 'http://us.megabus.com/JourneyResults.aspx?passengerCount=1'

  CODES = { "New York, NY" => 123, "Boston, MA" => 94 }

  def self.schedule(origin,destination,date)
    schedule = []
    url = query(origin,destination,date)
    details = search(url)
    details.each do |d|
      schedule << {
        company: "<a href=#{url}>Megabus</a>",

        departure_time: d.css('.two p').first.text
                         .gsub!(/\n|\t|\r/,"")
                         .scan(/(?<=Departs)\d{1,2}:\d{2}\S\w{2}/).first,

        arrival_time: d.css('.two p.arrive').first.text
                       .gsub!(/\n|\t|\r/,"")
                       .scan(/(?<=Arrives)\d{1,2}:\d{2}\S\w{2}/).first,

        price: d.css('.five p').text
                .scan(/[$]\d+.\d{2}/).first

      }
    end
    return schedule
  end

  def self.query(origin,destination,date)
    BASE + "&originCode=#{CODES[origin]}&destinationCode=#{CODES[destination]}&outboundDepartureDate=#{convert_date(date)}"
  end

  def self.search(url)
    return Nokogiri::HTML(open(url)).css(".journey")
  end

  def self.convert_date(date)
    d = date.split('-')
    n_d = "#{d[1]}-#{d[2]}-#{d[0]}"
  end


end

