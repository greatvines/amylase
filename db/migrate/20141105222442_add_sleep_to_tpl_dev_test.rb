class AddSleepToTplDevTest < ActiveRecord::Migration
  def change
    add_column :tpl_dev_tests, :sleep_seconds, :integer, default: 0
  end
end
