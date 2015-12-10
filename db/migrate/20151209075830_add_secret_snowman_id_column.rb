class AddSecretSnowmanIdColumn < ActiveRecord::Migration
  def change
    add_column :users, :secretsnowman_id, :integer
  end
end
