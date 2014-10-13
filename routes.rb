get '/' do
  # @today =
  # @tomorrow =
  erb :index
end

get '/result' do
  puts params
  @origin = params[:origin]
  @destination = params[:destination]
  @date = params[:date]
  results = []
  [GoToBus,Megabus,LuckyStar,PeterPan].each do |bus|
    results << bus.schedule(@origin,@destination,@date)
  end
  @results = results.flatten.sort_by { |k| k[:price] }
  erb :result
end
