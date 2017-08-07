require_relative '../test_db_conn' 

# 要测试的文件
require_relative '../../helpers/api_helper'

class ApiHelperTest < TestDbConn
  def setup
    super
    @methods_names = %w[ api_should model_get_data jwt_encode
                         jwt_decode SHA1 MD5 current_member 
                         polish_comment login_member_info plural_name
                         up_upload init_UPyun show_image_cloud_file_lists ]
  end

  def test_api_should
    assert mocked_obj.method(:api_should).arity == 0 # 参数

    # 验证必须只能传入 block
    assert_raises ArgumentError do
      mocked_obj.api_should('is_not_block') {} 
    end

    # 验证回传必须是 json 并且有 key 为 success
    result = mocked_obj.api_should do
     {msg: 'test_hash'} 
    end 

    assert JSON.parse(result).has_key?("success") == true
  end

  def test_plural_name
    assert mocked_obj.method(:plural_name).arity == 1 # 参数
    assert mocked_obj.send(:plural_name, Tag) == 'tags'
  end

  def test_str2model
    assert mocked_obj.method(:str2model).arity == 1 # 参数

    # 继承于 ActiveRecord::Base 所有子类 to_s 后每个测试该方法
    ActiveRecord::Base.descendants.map(&:to_s).each do |model_name|
     assert mocked_obj.str2model(model_name).is_a? Class
    end
  end

  def test_model_get_data
    params = {"invliad"=>"invliad"}

    post = Post.create!(title: '测试文章', content: '测试内容') 
    post2 = Post.create!(title: '测试文章2', content: '测试内容2') 
    # 创建 15 条评论
    i = 1
    loop do
      # comment = Comment.create!(post_id: post.id, content: "测试评论#{i.to_s}") 
      tag = Tag.create!(name: "测试标签#{i.to_s}")
      Pt.create!(post_id: post.id, tag_id: tag.id)
      i += 1
      break if i == 15  
    end
    
    # 1. 测试必传参数 model
    assert mocked_obj.model_get_data(params) == {success: 0, msg: 'model参数不可为空'}
    # 2. 测试默认 limit 为 10 current_page 为 1
    params.merge!({"model"=>"Tag"})
    assert mocked_obj.model_get_data(params)[:json_data].size == 10
    # 3. sort_by 这边测试 id 降序 
    params.merge!({"order_params"=>{"sort_by"=>"id", "order"=>"DESC"}})
    json_data = mocked_obj.model_get_data(params)[:json_data]
    assert json_data[0]['id'] > json_data[9]['id']
    # 4. 关联模型查找 从关联表中的 key为 related_object[:key] 中获得 value 为 related_object[:value] 的对象的
    #    related_object[:group]的对象
    related_query_params = {"related_object" => 
                            { through_model: 'Pt', 
                              related_model: 'Tag', 
                              key: 'tag_id', 
                              value: Tag.all.group(:id).size.keys, 
                              group: 'post_id'},
                            "model"=>"Post"  
                            }
    params.merge!(related_query_params)
    assert mocked_obj.model_get_data(params)[:json_data][0]['id'] = post.id
    # 5. query_params => {query_params: {"title" => "测试文章"}}
    params.merge!({"query_params" => {"title" => "测试文章"}})
    assert mocked_obj.model_get_data(params)[:json_data][0]['id'] = post.id
    params.merge!({"query_params" => {"title" => "测试文章不存在的"}})
    assert mocked_obj.model_get_data(params)[:json_data].size == 0
    # 6. {"fuzzy_query_params" => {"title" => '测试'}}
    params = { "fuzzy_query_params" => {"title" => '测试'}, "model"=>"Post" }
    assert mocked_obj.model_get_data(params)[:json_data].size == 2
  end

  def mocked_obj
    Object.new.extend(ApiHelper)
  end

end

