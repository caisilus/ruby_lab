class CreateLabsTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :labs_tasks do |t|
      t.references :lab
      t.references :task

      t.timestamps
    end
  end
end
