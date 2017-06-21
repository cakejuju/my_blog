class  MyApp

  # 将所有 api 包围 begin rescure
  def api_should(&block)
    begin
      block.call.suc_json
    rescue Exception => e
      {success: 0, msg: e.to_s}.fail_json
    end
  end

  def model_get_data(params)
    begin
      params = params.with_indifferent_access # hash 可以用 symbol 或 string 取值
      p params
      # 获取limit, current_page , model, 必填参数
      limit = params[:limit].to_i
      limit = 30 if limit == 0

      current_page = params[:current_page].to_i
      current_page = 1 if current_page == 0

      model = params[:model].to_s.constantize  # 得到对象模型

      period = params[:period]

      # 获取关联对象

      data_ids = params[:related_object] ? get_ids(model, params[:related_object]) : nil

      if data_ids.present?
        queried_data = model.where(id: data_ids)
      else
        queried_data = model.all      
      end
      # p queried_data
      if period.present?
        queried_data = queried_data.where(:created_at => period[:begin_time].to_datetime.to_datetime..period[:end_time].to_datetime.to_datetime)
      end

      include_model = params[:include_model]

      queried_data = queried_data.includes(include_model.split(',')) if include_model.present?

      # 得到排序参数
      order_params = params[:order_params]
      # 若排序参数为空 会默认按created_at时间降序 (没有 created_at 字段的情况?)
      if order_params.present?
        sort_by = order_params[:sort_by]
        order = order_params[:order]
        queried_data = queried_data.order("#{sort_by} #{order}")
      else
        queried_data = queried_data.order('created_at DESC')
      end

      # 得到查询参数
      query_params = params[:query_params]

      if query_params.present?
        query_params.each do |key, value|
          value = value == 'nil' ? nil : (value.is_a?(Array) ?  value.split(',') : value)
          queried_data = queried_data.where(key => value)
        end
      end

      # 得到模糊查询参数
      fuzzy_query_params = params[:fuzzy_query_params]
      if fuzzy_query_params.present?
        fuzzy_query_params_key = fuzzy_query_params[:key]
        fuzzy_query_params_value = fuzzy_query_params[:value]
        if fuzzy_query_params_value.present?
          fuzzy_query_params_value.each_char do |char|
            queried_data = queried_data.where("#{fuzzy_query_params_key} LIKE ?", "%#{char}%")
          end
        end
      end

      total_pages = (queried_data.size / limit.to_f).ceil  # 向上取整

      offset = limit*(current_page - 1)  # 分页左边起始位置

      relation_data = queried_data.limit(limit).offset(offset)

      as_json_options = {} # as_json 方法的选项 有.as_json( methods: [], only: [])

      as_json_options.merge!({methods: params[:json_methods]}) if params[:json_methods].present?
      as_json_options.merge!({only: params[:json_only]}) if params[:json_only].present?

      json_data = relation_data.as_json(as_json_options)

      returned_data = { success: 1,
                        total_pages: total_pages,
                        current_page: current_page,
                        counts: queried_data.size,
                        json_data: json_data }
      returned_data.merge!({ relation_data: relation_data }) if params[:relation_data] 
            
      return returned_data
    rescue Exception => e
      return {success: 0, msg: e.to_s}
    end
  end

  private
  # 注意 group 只能是 id
  # related_object => {through_model: 'Pt', related_model: 'Tag', key: 'tag_id', value: [1,2,3], group: 'post_id'}
  def get_ids(model, related_object)
    # 中间模型
    through_model = str2model(related_object[:through_model]) # Pt Pt.where(tag_id: [1,2]).group(:post_id).size.keys
    # 关联的模型 查询条件模型
    related_model = str2model(related_object[:related_model]) # Tag 

    key = related_object[:key]
    value = related_object[:value]
    group = related_object[:group]

    # 被 group 的模型 id, 即要得出数据的模型
    grouped_model_ids = through_model.where(key => value).group(group).size.keys
    # p grouped_model_ids
    objs = model.where(id: grouped_model_ids)
    new_ids = []
    objs.each do |obj|
      related_ids = obj.send(plural_name(related_model)).group(:id).size.keys

      if value - related_ids == []
        new_ids << obj.id
      end
    end

    new_ids
  end

  def plural_name(model)
    ActiveModel::Naming.plural(model)
  end

  def str2model(str)
    str.to_s.constantize
  end

  def jwt_encode(data)
    algorithm = 'HS256'
    exp = Time.now.to_i + 3600 * 48 
    payload = {:exp => exp, :iss => 'joey'}.merge!(data)
    hmac_secret = '--A Secret--'
    return JWT.encode payload, hmac_secret, algorithm
  end

  def jwt_decode(token)
    begin
      algorithm = 'HS256'
      hmac_secret = '--A Secret--'
      data = JWT.decode token, hmac_secret, true, { :algorithm => algorithm }
      {success: 1, data: data, msg: 'success'}
    rescue JWT::ExpiredSignature
      {success: 0, msg: '登陆信息过期辣'}
    rescue Exception => e
      {success: 0, msg: e.to_s}
    end
  end

  def SHA1(str)
    Digest::SHA1.hexdigest(str)
  end

  def MD5(str)
    Digest::MD5.hexdigest(str)
  end

  def current_member
    token = cookies[:jwt]
    return false unless token

    decode_info = jwt_decode(token)

    if decode_info[:success] == 1
      # decode_info[:data] =>  

      # [{"exp"=>1494592675, "iss"=>"joey", "member_id"=>1, "is_master"=>true, "head_img_url"=>"", "username"=>"cakejuju"}, 
      # {"typ"=>"JWT", "alg"=>"HS256"}]
      FlexibleObject.new decode_info[:data][0]
    else 
      nil
    end
  end
  
  # 评论优化
  # /n => /n/n
  # # => #### ## => ####  ### => ####
  def polish_comment(str)
    str = str.two_slashN
    arr = str.split("\n")
    arr.each_with_index do |v, index|
      if v.include?("#####")
      elsif v.include?("#### ")
      elsif v.include?("### ")
        arr[index] = v.gsub!("### ","#### ")
      elsif v.include?("## ")
        arr[index] = v.gsub!("## ","#### ")
      elsif v.include?("# ")
        arr[index] = v.gsub!("# ","#### ")
      end
    end
    str = arr.join("\n")
    str
  end

  def login_member_info(member)
    jwt = jwt_encode({ member_id: member.id, 
                       is_master: member.is_master,
                       head_img_url: member.head_img_url,
                       username: member.username,
                       nickname: member.nickname,
                       email:    member.email})

    data = {is_master: member.is_master, nickname: member.nickname, head_img_url: member.head_img_url, email: member.email }

    {jwt: jwt, current_member: data}.suc_json 
  end

  # 又拍云上传
  def up_upload(local_file_path, cloud_save_path)
    config = FlexibleObject.new(Settings.UPyun)

    key = config.key
    bucket = config.bucket
    # upyun = Upyun::Rest.new('blog-src', 'admin2', 'jj930328')
    # file = upyun.get('/production/heads')
    upyun = Upyun::Form.new(key, bucket, {})

    opts = {
      'save-key' => cloud_save_path,
      'content-type' => 'image/jpeg',
      'image-width-range' => '0,22024',
      'return-url' => ''
    }    

    res = upyun.upload(local_file_path, opts)
  end

  def init_UPyun
    config = FlexibleObject.new(Settings.UPyun)

    bucket = config.bucket  
    admin =   config.admin
    password = config.password

    upyun = Upyun::Rest.new(bucket, admin, password)   
  end

  # 又拍云显示路径下文件
  def show_image_cloud_file_lists(url)
    upyun = init_UPyun
    
    upyun.getlist(url)
  end




end