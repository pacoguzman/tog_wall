class CreateWallTable < ActiveRecord::Migration
  def self.up
    create_table "walls", :force => true do |t|
      t.references :profile, :null => false

      t.timestamps
    end

    add_index :walls, :profile_id
  end

  def self.down
    drop_table "users"
  end
end


