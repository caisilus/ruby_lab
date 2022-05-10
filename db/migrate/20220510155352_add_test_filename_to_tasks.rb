class AddTestFilenameToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :test_filename, :string
  end
end
