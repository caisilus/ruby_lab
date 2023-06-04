class AddDefaultForPartialFilenameInTasks < ActiveRecord::Migration[7.1]
  def change
    change_column_default :tasks, :partial_filename, "default"
  end
end
