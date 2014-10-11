get '/' do
  erb :index
end

get '/result' do
  origin = params[:origin]
  destination = params[:destination]
  roundtrip = params[:roundtrip]
  departure_date = params[:depart_date]
  return_date = params[:return_date]
  @results = gotobus + megabus
  @luckystar = luckystar
  erb :result
end
