# -*- encoding : utf-8 -*-
ENV['RACK_ENV'] = 'test' # ensure env is test

require 'minitest/autorun'
require 'rack/test'

class TestBasic < Minitest::Test
  include Rack::Test::Methods
  def setup
  end

  # 测试所有 respond 的方法
  def test_response_to_methods
    @methods_names.each {|method_name| assert mocked_obj
                          .respond_to?(method_name) == true 
                        } if @methods_names && @class_name
  end

  # 默认不带参数 子类可通过覆写该方法实例化
  def mocked_obj
    @class_name.send(:new)
  end
end

