# 模块：基础
# 表名：商户表
class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      # t.integer  :id #企业编号，五位数字
      t.string   :nickname
      t.string   :username
      t.string   :password
      t.string   :email
      t.boolean  :is_master
      t.timestamps
    end
  end
end