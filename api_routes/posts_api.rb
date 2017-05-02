class MyApp < Sinatra::Application

  post '/get_posts' do
    params = JSON.parse(request.body.read)

    params.merge!({model: 'Post', json_methods:['written_time', 'tag_names', 'l_content']})

    content_type :json
    model_get_data(params).to_json
  end  

  post '/get_posts_by_id' do
    params = JSON.parse(request.body.read)

    content_type :json
    Post.where(id: params['id']).take.as_json(methods:['written_time', 'tag_names', 'l_content']).to_json
  end  

  post '/get_posts_by_tag_id' do
    params = JSON.parse(request.body.read)

    content_type :json

    tag = Tag.find(params['tag_id'].to_i)

    tag.posts.as_json(methods:['written_time', 'tag_names', 'l_content']).to_json
    # Post.where(id: params['id']).take.as_json(methods:['written_time', 'tag_names', 'l_content']).to_json
  end  

end