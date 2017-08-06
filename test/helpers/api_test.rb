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

  def mocked_obj
    Object.new.extend(ApiHelper)
  end

end

