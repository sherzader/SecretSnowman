class AddTastetoUsers < ActiveRecord::Migration
  def change
    add_column :users, :taste, :text
  end
end
