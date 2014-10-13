class BoltBus

  URL = "https://www.boltbus.com/"

  def self.search
    agent = Mechanize.new
    page = agent.get(url)
    form = page.form
    form.field_with(name: 'ctl00$cphM$forwardRouteUC$lstRegion$textBox').value="Northeast"
    form.field_with(name: 'ctl00$cphM$forwardRouteUC$lstOrigin$textBox').value="Boston South Station - Gate 9 NYC-Gate 10 NWK/PHL"
    form.field_with(name: 'ctl00$cphM$forwardRouteUC$lstDestination$textBox').value="New York  W 33rd St & 11-12th Ave (DC,BAL,BOS,PHL)"
    form.field_with(name: 'ctl00$cphM$forwardRouteUC$txtDepartureDate').value="10/16/2014"
    form.add_field!('__EVENTTARGET','ctl00$cphM$forwardRouteUC$CalendarChanger')
    form.add_field!('__EVENTARGUMENT','')
    # page = form.submit
    sleep(2)
    return page.search('body')

    # b = Watir::Browser.new :phantomjs
    # b.goto url
    # b.image(id: 'ctl00_cphM_forwardRouteUC_lstRegion_imageE').when_present.click
    # #Northeast:
    #   b.link(id: 'ctl00_cphM_forwardRouteUC_lstRegion_repeater_ctl01_link').when_present.click
      # Baltimore-1578 Maryland Ave. (near Marc-Penn Sta)
      # Boston South Station - Gate 9 NYC-Gate 10 NWK/PHL
      # Greenbelt, MD Metrorail Intermodal Station
      # New York W 33rd St & 11-12th Ave (DC,BAL,BOS,PHL)
      # New York 1st Ave Between 38th & 39th (To BOS)
      # New York 6th Ave Between Grand & Watts (DC or Phl)
      # Newark, NJ (Newark Penn Station)
      # Philadelphia - Cherry Hill, NJ (Cherry Hill Mall)
      # Philadelphia JFK & N. 30th St
      # Washington (Union Station-50 Mass. Ave), DC
    #Westcoast:
     # b.link(id: 'ctl00_cphM_forwardRouteUC_lstRegion_repeater_ctl02_link').clicl
      # Albany, OR (112 SW 10th Ave)
      # Barstow, CA (Carl's Jr., 2856 Lenwood Rd.)
      # Bellingham, WA (4194 Cordata Pkwy.)
      # Eugene, OR (5th Street Market)
      # Las Vegas, NV (500 S. 1st Street.)
      # Las Vegas, NV (LINQ-High Roller Ferris Wheel)
      # Los Angeles, CA (Union Station)
      # Oakland, CA (West Oakland BART Station)
      # Portland, OR (SW Salmon St. between 5th & 6th Ave)
      # San Francisco, CA (200 Folsom) Greyhound Slip 1
      # San Jose, CA (Diridon Station)
      # Seattle, WA (5th Avenue South @ S. King St)
      # Vancouver, BC (1150 Station Street-Gate 4)
    # b.image(id: 'ctl00_cphM_forwardRouteUC_lstOrigin_imageE').when_present.click
    # b.link(text: "Baltimore-1578 Maryland Ave. (near Marc-Penn Sta)").when_present.click

    # b.image(id: 'ctl00_cphM_forwardRouteUC_lstDestination_imageE').when_present.click
    # b.link(text: "Newark, NJ (Newark Penn Station)").when_present.click
    # page = agent.get(url, [], nil, {'User-agent'=>'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1'})
    # form = page.forms.first


    # form['__EVENTTARGET']='ctl00$cphM$forwardRouteUC$lstRegion$repeater$ctl01$link'
    # form['__EVENTARGUMENT']=''
    # form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstRegion$textBox")[0].value = "Northeast"

    # form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstOrigin$textBox")[0].value = "Boston South Station - Gate 9 NYC-Gate 10 NWK/PHL"
    # form.fields_with(name: "ctl00$cphM$forwardRouteUC$lstDestination$textBox")[0].value = "New York  W 33rd St & 11-12th Ave (DC,BAL,BOS,PHL)"
    # return 'dog'
    # b = Watir::Browser.new :phantomjs
    # b.goto url
    # b.

  end
end

