class PeterPan

  BASE = "https://tds.peterpanbus.com/"

  def self.schedule(origin,destination,date)
    schedule = []
    details = search(origin,destination,date)
    details.split("\nView Schedule Stops\nSelect\n").each do |d|
      dets = d.split("\n")
      schedule << {
        company: "<a href=#{BASE}>Peterpan</a>",
        departure_time: dets[0],
        arrival_time: dets[1],
        price: dets[3]
      }
    end
    return schedule
  end

  def self.search(origin,destination,date)
    b = Watir::Browser.new :phantomjs
    b.goto(BASE)
    form = b.iframe(id: 'frame-one')
    form.radio(value: "radio13").set
    form.select_list(name: "trip:origin:fieldFrag:field-border:field-border_body:field-container:field")
        .select("#{origin}")
    form.text_field(name: 'trip:destination:fieldFrag:field-border:field-border_body:field-container:field')
        .set("#{destination}")
    form.text_field(name: 'trip:travelDates:dates-border:dates-border_body:departDate:fieldFrag:field-border:field-border_body:field-container:field')
        .set("#{date}")
    form.button(type: 'submit').click
    return b.iframe(id: 'frame-one').ul(class: 'schedule-list').when_present.text
  end

end
