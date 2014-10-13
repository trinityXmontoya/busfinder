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
  @results = (gotobus + megabus + luckystar + peterpan).sort_by { |k| k[:price] }
  @boltbus = boltbus
  erb :result
end
