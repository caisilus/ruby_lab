class CreateLabs < ActiveRecord::Migration[7.0]
  def change
    create_table :labs do |t|
      t.string :title, null: false, unique: true
      t.boolean :opened, null: false, default: false
      t.string :content_path, null: false
      t.references :group
      t.timestamps
    end
  end
end