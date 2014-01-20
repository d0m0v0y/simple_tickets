class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :reporter_name
      t.string :reporter_email
      t.string :subject
      t.text :description
      t.integer :user_id

      t.timestamps
    end
    add_index :issues, :reporter_email
    add_index :issues, :user_id
  end
end
