class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.text :name

      t.timestamps
    end
  end
end
