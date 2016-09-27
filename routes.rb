get '/' do
  cache_control :public, :max_age => 43200
  @today = today_search
  @tomorrow = tmrw_search
  erb :index, cache: false
end

get '/result' do
  @origin = params[:origin]
  @destination = params[:destination]
  @date = params[:date]
  @results = general_search(@origin,@destination,@date)
  erb :result, cache: false
end

get '/about' do
  erb :about
end
