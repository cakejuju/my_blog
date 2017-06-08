class MyApp < Sinatra::Application
  post '/admin/get_posts' do 
    @params.merge!({model: 'Post', 
                    json_methods:['written_time', 'tag_names', 
                                  'l_content', 'created_strftime']})
    
    model_get_data(@params).suc_json
  end

  post '/admin/posts/create' do 
    # 新建博客
    begin
      title = @params[:title]
      return {msg: 'missing title'}.fail_json unless title.present?

      content = @params[:content]

      post = Post.create!(title: title, content: content)
      # 绑定 tags
      parma_tags = @params[:tags].split('|') # => ['ruby','py']
      parma_tags.each do |tag_name|
        tag = find_the_tag_or_create(tag_name)
        Pt.create(tag_id: tag.id, post_id: post.id)
      end
      {post: post}.suc_json
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end
  end

  post '/admin/posts/update_height' do 
    begin
      post_id = @params[:post_id]
      height = @params[:height].to_i
      post = Post.find_by(id: post_id)
      post.update(height: height)
      {}.suc_json
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end
  end
  post '/admin/posts/update' do 
    # 更新博客
    begin
      # 目前被更新的可以是博客的 标题 内容 标签
      # TODO 与前端页面的更新保持一致
      post_id = @params[:post_id]

      post = Post.find(post_id)

      title = @params[:title]
      content = @params[:content]

      post.update(title: title, content: content)

      parma_tags = @params[:tags].split('|') # => ['ruby','py']

      post_tags = post.tags.group(:name).size.keys # => ['py', 'ruby']
      # 更新标签
      # 标签发生变化
      need_to_be_del_tags = post_tags - parma_tags

      return {}.suc_json if parma_tags.size == post_tags.size && need_to_be_del_tags.empty?

      # 去除已经不需要关联的 tag
      if need_to_be_del_tags.present?
        need_to_be_del_tags.each do |tag_name|
          tag = Tag.find_by(name: tag_name)
          next unless tag
          pt = Pt.find_by(tag_id: tag.id, post_id: post.id)
          pt.destroy if pt
        end
      end
      need_to_be_add_tags = parma_tags - post_tags
      # 增加需要新关联的 tag
      if need_to_be_add_tags.present?
        need_to_be_add_tags.each do |tag_name|
          tag = find_the_tag_or_create(tag_name)
          Pt.create(tag_id: tag.id, post_id: post.id)
        end
      end

      {}.suc_json
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end
  end

  # 在 post new 和 edit 中都会用到的 tag 方法
  # 若找到名为 xxx 的标签,则直接返回, 否则创建该标签并返回
  def find_the_tag_or_create(tag_name)
    tag = Tag.find_by(name: tag_name)
    return tag if tag 
    tag = Tag.create!(name: tag_name)
    tag
  end

end