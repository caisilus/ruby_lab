class AddLabRefToTask < ActiveRecord::Migration[7.0]
  def up
    if Lab.any?
      add_reference :tasks, :lab, foreign_key: true
      Task.update_all(lab_id: Lab.first.id)
      change_column_null :tasks, :lab_id, false
    else
      add_reference :tasks, :lab, foreign_key: true, null: false
    end
  end

  def down
    remove_reference :tasks, :lab
  end
end
