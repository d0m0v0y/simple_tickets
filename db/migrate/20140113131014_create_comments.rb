class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :body
      t.integer :issue_id

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :issue_id
  end
end
