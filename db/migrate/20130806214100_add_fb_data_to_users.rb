class AddFbDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :picture_url, :string
    add_column :users, :name, :string
  end
end
