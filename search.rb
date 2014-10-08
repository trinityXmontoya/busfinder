def gotobus
  url = "http://search.gotobus.com/search/bus.do?option=Select&is_roundtrip=0&submit_flag=submit_flag&roundtrip=0&bus_from=Boston%2C+MA&bus_to=New+York%2C+NY&filter_date=2014-10-08&return_date=&adult_num=1"
  details = []
  table = Nokogiri::HTML(open(url)).css("#listarea .b_s_result table")
  table.each do |t|
    # gotobus doesn't have any more unique class or ids
    td = t.css("tr .n_b_s_se")
    details << {
      company: "gotobus",
      departure_time: td[0].content,
      arrival_time: td[1].content,
      price: td[5].content.strip()
    }
  end
  return details
end


# def peterpan
#   url = "https://tds.peterpanbus.com/"
#   form = Mechanize.new.get(url).iframes.first.click.forms.first
#   fields = form.fields

#   #destination city
#   fields[1].value = destination

#   #travel dates dates
#   fields[2].value = departure_date

#   # origin
#   fields[3].value = origin

#   page = form.submit
# end





