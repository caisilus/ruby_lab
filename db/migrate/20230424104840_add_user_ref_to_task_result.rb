class AddUserRefToTaskResult < ActiveRecord::Migration[7.0]
  def up
    add_reference :task_results, :user, foreign_key: true
    TaskResult.update_all(user_id: User.first.id)
    change_column_null :task_results, :user_id, false
  end

  def down
    remove_reference :task_results, :user
  end
end
