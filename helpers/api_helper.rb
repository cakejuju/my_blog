class  MyApp
  def model_get_data(params)
    begin
      params = params.with_indifferent_access # hash 可以用 symbol 或 string 取值

      # 获取limit, current_page , model, 必填参数
      limit = params[:limit].to_i
      limit = 30 if limit == 0

      current_page = params[:current_page].to_i
      current_page = 1 if current_page == 0

      model = params[:model].to_s.constantize  # 得到对象模型

      period = params[:period]

      if period.present?
        queried_data = model.where(:created_at => period[:begin_time].to_datetime.to_datetime..period[:end_time].to_datetime.to_datetime)
      else
        queried_data = model.all                  
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
          value = value == 'nil' ? nil : value.split(',')
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

      offset = limit*(current_page -1)  # 分页左边起始位置

      relation_data = queried_data.limit(limit).offset(offset)

      as_json_options = {} # as_json 方法的选项 有.as_json( methods: [], only: [])

      as_json_options.merge!({methods: params[:json_methods]}) if params[:json_methods].present?
      as_json_options.merge!({only: params[:json_only]}) if params[:json_only].present?

      json_data = relation_data.as_json(as_json_options)

      return { success: 1,
               total_pages: total_pages,
               current_page: current_page,
               counts: queried_data.size,
               json_data: json_data,
               relation_data: relation_data }
    rescue Exception => e
      return {success: 0, reason: e.to_s}
    end
  end

end