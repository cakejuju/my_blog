class MyApp < Sinatra::Application

  post '/get_posts' do
    @params.merge!({model: 'Post', json_methods:['written_time', 'tag_names', 'l_content', 'created_strftime']})
    
    model_get_data(@params).to_json
  end  

  post '/get_posts_by_id' do
    post = Post.where(id: @params['id']).take
    if post
      earlier_post = Post.where('created_at < ?', post.created_at).order('created_at DESC').limit(1).take
      later_post = Post.where('created_at > ?', post.created_at).limit(1).take
      data = { earlier_post: earlier_post,
               later_post: later_post,
               post: post.as_json(methods:['written_time', 'tag_names', 'l_content']) }     
    else
      data = {}          
    end

    data.to_json
  end  

  # post '/get_posts_by_title' do
  #   

  #   content_type :json
  #   # post = Post.find_by(title: @params['title']).as_json(methods:['written_time', 'tag_names', 'l_content'])

  #   Post.find_by(title: @params['title']).as_json(methods:['written_time', 'tag_names', 'l_content']).to_json
  # end  

  post '/get_posts_by_tag_id' do
    tag = Tag.find(@params['tag_id'].to_i)

    tag.posts.as_json(methods:['written_time', 'tag_names', 'l_content']).to_json
  end  





end