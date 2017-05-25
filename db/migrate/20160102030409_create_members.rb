
class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string   :nickname
      t.string   :username # 因为不存在好友系统, 用 username 登陆用户名去判断 member 的 唯一
      t.string   :password
      t.string   :email
      t.boolean  :is_master
      t.string   :head_img_url, default: ''
      t.timestamps
    end
  end
end