
class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string   :nickname
      t.string   :username
      t.string   :password
      t.string   :email
      t.boolean  :is_master
      t.timestamps
    end
  end
end