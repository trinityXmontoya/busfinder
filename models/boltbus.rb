class BoltBus

  BASE = "https://www.boltbus.com/"

  def self.search(origin,destination,date)
    b = Watir::Browser.new :phantomjs
    b.goto BASE
    # select region: northeast
    b.image(id: "ctl00_cphM_forwardRouteUC_lstRegion_imageE").when_present.click
    b.link(id: "ctl00_cphM_forwardRouteUC_lstRegion_repeater_ctl01_link").when_present.click
    b.image(id: "ctl00_cphM_forwardRouteUC_lstRegion_imageE").when_present.click
    # select origin
    b.image(id: "ctl00_cphM_forwardRouteUC_lstOrigin_imageE").when_present.click
    b.link(text: Regexp.new(origin.split(",")[0])).when_present.click
    b.image(id: "ctl00_cphM_forwardRouteUC_lstOrigin_imageE").when_present.click
    # select destination
    b.image(id: "ctl00_cphM_forwardRouteUC_lstDestination_imageE").when_present.click
    b.link(text: Regexp.new(destination.split(",")[0])).when_present.click
    b.image(id: "ctl00_cphM_forwardRouteUC_lstDestination_imageE").when_present.click
    # select date
    b.image(id: "ctl00_cphM_forwardRouteUC_imageE").when_present.click
    b.td(text: date.strftime("%d")).when_present.click

    table = b.table(class: "fareview").html
    doc = Nokogiri::HTML.parse(table)

    b.close

    return doc.css("tr")
  end

  def self.schedule(origin, destination,date)
    begin
      details = search(origin,destination,date)
      details.collect do |d|
        td = d.css("td")
        price = td[0].text.strip
        unless price == "N/A" || price == "Sold Out"
          {company: "<a href=#{url}>#{td[3].text.strip}</a>",
           departure_time: td[1].text.strip,
           arrival_time: td[2].text.strip,
           price: price == "" ? "Unavailable*" : "#{price}"}
        end
      end
    rescue
      []
    end
  end

end
