class AddTypeCommonToGraffities < ActiveRecord::Migration

  def self.up
    add_column :graffities, :type_common, :boolean, :null => false, :default => true
  end


  def self.down
    remove_column :graffities, :type_common
  end
end
