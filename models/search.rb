def general_search(origin,destination,date)
  results = []
  [GoToBus,Megabus,LuckyStar].each do |bus|
    results << bus.schedule(origin,destination,date)
  end
  return results.flatten.sort { |a,b| [a[:price], a[:departure_time]]<=>[b[:price], b[:departure_time]] }
end

def today_search
  general_search("Boston, MA","New York, NY",Date.today.to_s)
end

def tmrw_search
  general_search("Boston, MA","New York, NY",(Date.today + 1).to_s)
end


