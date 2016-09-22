def general_search(origin,destination,date)
  lines = [GoToBus, LuckyStar, Megabus, PeterPan]
  lines.collect { |l| l.schedule(origin, destination, date) }
       .flatten
       .sort { |a,b| [a[:price], a[:departure_time]]<=>[b[:price], b[:departure_time]] }
end

def today_search
  general_search("Boston, MA","New York, NY",Date.today)
end

def tmrw_search
  general_search("Boston, MA","New York, NY",(Date.today + 1))
end
