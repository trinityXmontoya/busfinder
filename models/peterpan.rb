class PeterPan

  BASE = "https://webstore.tdstickets.com/service/step1Submit/3743?s=f9f3476d-7bc5-4a19-9e65-fd75cade13b4"
  CODES = { "New York, NY" => "151239", "Boston, MA" => "040030" }

  def self.schedule(origin,destination,date)
    schedule = []
    details = search(origin,destination,date)
    if details.class == Hash
      return details
    else
      details.each do |d|
        schedule << {
          company: "<a href=#{BASE}>Peter Pan</a>",
          departure_time: remove_zero_padding(d.css(".departInfo .time").text),
          arrival_time: remove_zero_padding(d.css(".arrivalInfo .time").text),
          price: "#{d.css(".scheduleFare .primaryText:not(.cityName)").text}.00"
        }
      end

      if schedule == []
        return {error: "No results"}
      else
        return schedule
      end
    end
  end

  def remove_zero_padding(time)
    Time.parse(time).strftime("%l:%m%p").strip
  end

  def self.search(origin,destination,date)
    opts = {
    "ada"=> "false",
    "adults"=> "1",
    "adultsHandicap"=> "0",
    "child2"=> "0",
    "child5"=> "0",
    "childrenHandicap"=> "0",
    "departDate"=> date.strftime("%m%d"),
    "departDateUnformatted"=> date.strftime("%m/%d/%Y"),
    "destination"=> CODES[destination],
    "destinationName"=> destination,
    "isStudent"=> "false",
    "origin"=> CODES[origin],
    "originName"=> origin,
    "seniors"=> "0",
    "seniorsHandicap"=> "0",
    "students"=> "0",
    "totalPassengers"=> "1",
    "tripType"=> "One Way",
    "webDiscount"=> "true"
    }

    begin
      clnt = HTTPClient.new
      res1 = clnt.post(BASE, opts, follow_redirect: true)
      redirect_url = JSON.parse(res1.body)["redirect"]
      res2 = clnt.get(redirect_url, follow_redirect: true)
      doc = Nokogiri::HTML(res2.body)
      return doc.css(".schedules div.schedule:not(.soldOut)")
    rescue
      return {error: "server"}
    end
  end

end
