class RenameContentPathInTasks < ActiveRecord::Migration[7.1]
  def change
    rename_column :tasks, :content_path, :partial_filename
  end
end
