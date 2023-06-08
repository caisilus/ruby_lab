class RenameGroupsToUnits < ActiveRecord::Migration[7.1]
  def change
    rename_table :groups, :units
    rename_column :labs, :group_id, :unit_id
  end
end
