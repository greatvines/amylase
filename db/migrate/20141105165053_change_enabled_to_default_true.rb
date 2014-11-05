class ChangeEnabledToDefaultTrue < ActiveRecord::Migration
  def up
    change_column :job_specs, :enabled, :boolean, default: true
  end

  def down
    change_column :job_specs, :enabled, :boolean, default: false
  end
end
