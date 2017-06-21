class MyApp < Sinatra::Application

  # 对评论进行操作的需要验证
  before '/comments/operate/*' do
    @member = current_member
  end

  before '/comments/*' do
    @json_methods = ['head_img_url', 'nickname', 'marked_content', 'written_time']
    @model = 'Comment'
  end  

  # 增加评论
  post '/comments/operate/create' do
    begin
      return {success: 0, msg: '登陆失效辣'}.to_json unless @member
      content = @params[:content]
      if content.present?
        content = polish_comment(content)
        destination = @params[:destination]
        case destination
        when 'post' 

          comment = Comment.create!(post_id: @params[:post_id].to_i, 
                                    content: content,
                                    destination: destination,
                                    member_id: @member.member_id.to_i)
        when 'member'  
        end

        { success: 1, msg: '评论成功', 
          comment: comment.as_json(methods: @json_methods)}.to_json  
      else 
        {success: 0, msg: '不能啥也不说哦'}.to_json                
      end
 
    rescue Exception => e
      {success: 0, msg: e.to_s}.to_json      
    end
  end

  post '/comments/getData' do 
    api_should do
      @params.merge!({model: @model, json_methods: @json_methods})
    
      data = model_get_data(@params)
      # p data
      data
    end
  end


end
