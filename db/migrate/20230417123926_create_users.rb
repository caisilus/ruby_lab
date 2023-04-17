class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :github_login, unique: true, null: false
      t.string :name, null: false
      t.string :middle_name
      t.string :surname, null: false
      t.string :repo_link

      t.timestamps
    end
  end
end
