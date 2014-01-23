class AddUiDtoIssue < ActiveRecord::Migration
  def change
    add_column :issues, :uid, :string
  end
end
