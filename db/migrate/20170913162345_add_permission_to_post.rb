class AddPermissionToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :permission, :string, default: 'public'
  end
end