class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer  :post_id
      t.text     :content
      t.string   :destination    # post or member 评论可以对文章 可以对人
      t.string   :at_nick_name   # @昵称 显示在评论中
      t.string   :at_user_name   # 因为不存在好友系统, @时 用 username 登陆用户名去判断 member 的 唯一
      t.integer  :member_id
      t.timestamps
    end
  end
end
