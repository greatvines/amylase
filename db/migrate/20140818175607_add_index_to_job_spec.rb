class AddIndexToJobSpec < ActiveRecord::Migration
  def change
    add_index :job_specs, :name, unique: true
  end
end
