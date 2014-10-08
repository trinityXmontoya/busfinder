get '/' do
  erb :index
end

get '/bus' do
  origin = params[:origin]
  destination = params[:destination]
  roundtrip = params[:roundtrip]
  departure_date = params[:departure_date]
  return_date = params[:return_date]
  @results = gotobus + megabus
  erb :bus
end

get '/about' do
  erb :about
end

get '/results' do
  erb :results
end
