class CreateTaskResults < ActiveRecord::Migration[7.0]
  def change
    create_table :task_results do |t|
      t.references :task
      t.integer :passed_tests
      t.integer :total_tests

      t.timestamps
    end
  end
end
