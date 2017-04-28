class MyApp < Sinatra::Application

  post '/get_posts' do
    params = JSON.parse(request.body.read)
    # p params
    params.merge!({model: 'Post', json_methods:['written_time']})
    # p model_get_data()
    content_type :json
    model_get_data(params).to_json
  end  
end