class ChangeTplDevTestArgumentNull < ActiveRecord::Migration
  def up
    change_column :tpl_dev_tests, :argument, :text, null: true
  end

  def down
    change_column :tpl_dev_tests, :argument, :string, null: false
  end
end
