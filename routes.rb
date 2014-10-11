get '/' do
  erb :index
end

get '/result' do
  puts params
  @origin = params[:origin]
  @destination = params[:destination]
  @roundtrip = params[:roundtrip]
  @departure_date = params[:depart_date]
  @return_date = params[:return_date]
  @results = (gotobus + megabus).sort_by { |k| k[:price] }
  @luckystar = 'e'
  erb :result
end
