# 使用幽灵方法调用hash的值变成对象点调用 
# notice: 单层 hash
class FlexibleObject
  attr_reader :flexible_object

  def initialize(hash, *args)
    hash ||= {}
    @flexible_object = hash
  end

  def method_missing(key, *args)
    self.flexible_object[key.to_s] || self.flexible_object[key]
  end

end