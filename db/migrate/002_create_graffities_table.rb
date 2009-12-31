class CreateGraffitiesTable < ActiveRecord::Migration
  def self.up
    create_table :graffities do |t|
      t.references :profile, :null => false
      t.references :wall, :null => false
      t.string :title, :limit => 50, :default => ""
      t.string :comment, :default => ""
      t.boolean :approved
      t.boolean :spam
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      
      t.timestamps
    end

    add_index :graffities, :wall_id
    add_index :graffities, :profile_id
    add_index :graffities, :parent_id
  end

  def self.down
    drop_table :graffities
  end
end