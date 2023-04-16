class DropLabsTasks < ActiveRecord::Migration[7.0]
  def change
    drop_table :labs_tasks
  end
end
