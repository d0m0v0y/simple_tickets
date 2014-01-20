class AddDepartmentIdToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :department_id, :integer
  end
end
