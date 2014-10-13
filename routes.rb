get '/' do
  @today = today_search
  @tomorrow = tmrw_search
  # @today = [{company: "gotobus",
  #       departure_time: "9:00PM",
  #       arrival_time: "9:00PM",
  #       price: "$12.00"}]
  # @tomorrow =[{company: "gotobus",
  #       departure_time: "9:00PM",
  #       arrival_time: "9:00PM",
  #       price: "$12.00"}]
  erb :index
end

get '/result' do
  puts params
  @origin = params[:origin]
  @destination = params[:destination]
  @date = params[:date]
  @results = general_search(@origin,@destination,@date)
  erb :result, cache: false
end

get '/about' do
  erb :about, cache: false
end

# expire index cache each day at 12:01AM

# cache_expire('/')
