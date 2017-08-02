# 测试辅助类 该类可以连接测试数据库并用自动删除测试中产生的数据
require_relative '../test_db_conn' 
# 要测试的文件
require_relative '../../helpers/model_helper'

class ActiverecordBaseTest < TestDbConn
  # 测试给 ActiveRecord::Base 添加的方法
  def setup
    super
    @class_name = Tag
  end

  def test_second_time_to_text
    assert mocked_obj.method(:second_time_to_text).arity == 1 # 方法接收 1 个参数

    # 验证参数小于 0 时抛出异常
    assert_raises ArgumentError do
      mocked_obj.second_time_to_text -1000
    end

    # 验证不同情况下的返回值
    ass_data = [ [59.seconds.ago, "刚刚"], [3.minutes.ago, "3分钟前"], 
                 [23.hours.ago, "23小时前"], [5.days.ago,  "5天前"],
                 [2.weeks.ago,  "2周前"],[11.months.ago, "11月前"],
                 [10.years.ago, "10年前"] ]

    ass_data.each do |a|
      assert mocked_obj.second_time_to_text(a[0].dis_now) == a[1]
      #  => assert mocked_obj.second_time_to_text(59) == "刚刚"
    end
  end
end

class Time
  def dis_now
    (Time.now - self).to_i
  end
end
