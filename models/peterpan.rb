class PeterPan

  BASE = "https://tds.peterpanbus.com"

  def self.schedule(origin,destination,date)
    schedule = []
    details = search(origin,destination,date)
    if details.class == Hash
      return details
    else
      details.split("\nView Schedule Stops\nSelect\n").each do |d|
        dets = d.split("\n")
        schedule << {
          company: "<a href=#{BASE}>Peterpan</a>",
          departure_time: dets[0],
          arrival_time: dets[1],
          price: dets[3]
        }
      end
      if schedule == []
        return {error: "No results"}
      else
        return schedule
      end
    end
  end

  def self.search(origin,destination,date)
    begin
      b = Watir::Browser.new :phantomjs, :args => ['--ssl-protocol=tlsv1']
      b.goto(BASE)
      form = b.iframe(id: 'frame-one')
      form.radio(value: "radio11").set
      form.select_list(name: "trip:origin:fieldFrag:field-border:field-border_body:field-container:field:field")
          .select("#{origin}")
      form.select_list(name: "trip:destination:fieldFrag:field-border:field-border_body:field-container:field:field")
          .select("#{destination}")
      form.text_field(name: 'trip:travelDates:dates-border:dates-border_body:departDate:fieldFrag:field-border:field-border_body:field-container:field:field')
          .set("#{date}")
      form.button(type: 'submit').click
      if b.text.include? "There are no schedule available for this route on this carrier."
        return {error: "No results for Peter Pan at this time"}
      else
        return b.iframe(id: 'frame-one').ul(class: 'schedule-list').when_present.text
      end
    rescue
      return {error: "server"}
    end
  end

end
