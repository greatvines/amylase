class AddJobTemplateIndexToJobSpec < ActiveRecord::Migration
  def change
    add_index :job_specs, :job_template_id
  end
end
