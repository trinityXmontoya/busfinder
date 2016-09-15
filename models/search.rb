def general_search(origin,destination,date)
  results = []
  [GoToBus, LuckyStar, Megabus, PeterPan].each do |bus|
    res = bus.schedule(origin,destination,date)
    unless res.class == Hash
      results << res
    end
  end
  return results.flatten.sort { |a,b| [a[:price], a[:departure_time]]<=>[b[:price], b[:departure_time]] }
end

def today_search
  general_search("Boston, MA","New York, NY",Date.today)
end

def tmrw_search
  general_search("Boston, MA","New York, NY",(Date.today + 1))
end
