class MyApp < Sinatra::Application

  post '/get_posts' do
    api_should do
      # 非 admin 只能看公开的 post
      @params[:query_params] ||= {}
      @params[:query_params].merge!({permission: 'public'}) unless is_admin?

      @params.merge!({relation_data: true, model: 'Post'})

      model_data = model_get_data(@params)

      relation_data = model_data[:relation_data]

      queryString = @params[:queryString].to_s.delete(" ")
      # 当查询字符串不为空时,按照以下顺讯查询
      # 1: 查询相关 tag 名为此的 post
      # 2: 查询相关 title 名为此的 post
      # 3: 查询相关 content 名为此的 post

      if queryString.present?
        posts_id = []
        # 查询相关 tag
        tags = Tag.where("name LIKE ?", "%#{queryString}%")
        if tags.present?
          tags.each do |tag|
            posts_id += tag.posts.group(:id).size.keys
          end
        end

        # 查询相关 title
        title_posts = relation_data.where("title LIKE ?", "%#{queryString}%")
        posts_id += title_posts.group(:id).size.keys if title_posts.present?

        # 查询相关 content
        # content_posts = relation_data.where("content LIKE ?", "%#{queryString}%")
        # posts_id += content_posts.group(:id).size.keys if content_posts.present?

        posts_id.uniq!

        relation_data = relation_data.where(id: posts_id)            
      end

      json_data = relation_data.as_json(methods:['written_time', 'tag_names', 'l_content', 'created_strftime'],
                                        only: @params[:json_only])

      model_data.merge!(json_data: json_data)
    end
  end  

  post '/get_posts_by_id' do
    api_should do
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
      data
    end
  end  


  post '/get_posts_by_tag_id' do
    api_should do
      tag = Tag.find(@params['tag_id'].to_i)

      tag.posts.as_json(methods:['written_time', 'tag_names', 'l_content'])
    end
  end  


  # post '/get_posts_by_title' do
  #   

  #   content_type :json
  #   # post = Post.find_by(title: @params['title']).as_json(methods:['written_time', 'tag_names', 'l_content'])

  #   Post.find_by(title: @params['title']).as_json(methods:['written_time', 'tag_names', 'l_content']).to_json
  # end  


end