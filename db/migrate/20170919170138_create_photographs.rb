class CreatePhotographs < ActiveRecord::Migration[5.0]
  def change
    create_table :photographs do |t|
      t.string   :img_url
      t.string   :description 
      t.text     :exif

      t.timestamps
    end
  end
end