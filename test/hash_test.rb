require_relative './test_helper'
require_relative '../helpers/hash_extension'
require 'active_record'
class HashTest < TestBasic
  METHODS_NAME = %w[ suc_json fail_json ]

  def setup
    super
    @methods_names = METHODS_NAME
    @class_name = Hash
  end

  # define_test_methods
  # 定义类方法达到定义一下两个方法的作用
  # 注意必须先有此类方法才能调用(按照代码的顺序)

  # def test_suc_json
  #   assert JSON.parse(mocked_obj.suc_json)["success"] == 1

  #   assert JSON.parse({"success" => 1}.suc_json)["success"] == 1
  # end

  # def test_fail_json
  #   assert JSON.parse(mocked_obj.fail_json)["success"] == 0

  #   assert JSON.parse({"success" => 0}.fail_json)["success"] == 0
  # end

  def self.define_test_methods
    METHODS_NAME.each do |method|
      define_method ("test_#{method}") do 
        suc_value = case method
                    when 'suc_json' then 1
                    when 'fail_json' then 0
                    end
        assert JSON.parse( mocked_obj.send(method) )["success"] == suc_value
        assert JSON.parse( {"success" => suc_value}.send(method) )["success"] == suc_value
      end
    end
  end

  define_test_methods
end
