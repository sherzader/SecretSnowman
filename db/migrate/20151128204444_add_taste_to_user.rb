class AddTasteToUser < ActiveRecord::Migration
  def change
    add_column :user, :taste, :text
  end
end
