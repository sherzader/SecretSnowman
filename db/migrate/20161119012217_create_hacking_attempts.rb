class CreateHackingAttempts < ActiveRecord::Migration
  def change
    create_table :hacking_attempts do |t|
      t.integer :user_id, null: false
      t.string :description, null: false
      t.timestamps null: false
    end
  end
end
