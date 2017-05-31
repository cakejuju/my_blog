class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string   :title
      t.text     :content # 文章内容
      t.string   :img_url # 展示图片url
      t.integer  :height  # 高度 用于瀑布流展示 弃用 TODO remove
      t.string   :title_color # 标题栏颜色
      t.string   :title_text_color # 标题栏字体颜色
      t.string   :bottom_color # 底部颜色
      t.string   :bottom_text_color # 底部字体颜色

      t.timestamps
    end
  end
end
