class AddIndexNumberToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :index_number, :integer
  end
end
