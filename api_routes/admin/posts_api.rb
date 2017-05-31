class MyApp < Sinatra::Application
  post '/admin/get_posts' do 
    @params.merge!({model: 'Post', json_methods:['written_time', 'tag_names', 'l_content', 'created_strftime']})
    
    model_get_data(@params).to_json
  end
end